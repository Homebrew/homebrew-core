class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  license "Apache-2.0"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/1.4.0.tar.gz"
    sha256 "543443a253fe338d0dec4f4158d728806a8db65bdd4bf3dbe3d0afcd1361b495"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.17.0.tar.gz"
      sha256 "b3f0a2261437b21b3e2465b7755edf0c33f0305a112bd9a36e1b3ec74f96b098"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "bb8fa3d6661b12e3c186b51efa8bd0e98a9eec6d468e18bd98a3d1f6d36ed5ac"
    sha256 arm64_big_sur:  "7e887e1efc3b48650801a90e38da652f27b6482f80ff91b411594eedbedfe64f"
    sha256 monterey:       "bfde2b99b037c8749a9a88e70a5cdf5aa68002863164b7507fd4fecdc3681d56"
    sha256 big_sur:        "c3f4173fb9fb81b529506d8078866740bb83f4bc1b9784ef2f7d19212fb87d8b"
    sha256 catalina:       "c7f9765798c1bf561d6a74b5a3b16635fc7cbe6769d690c0db65667add97bf24"
    sha256 x86_64_linux:   "6ed1b7a0292675183c1f49aac61d8c93156b77dca2802b4425468522e3c0ae18"
  end

  head do
    url "https://github.com/crystal-lang/crystal.git"

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git"
    end
  end

  depends_on "bdw-gc"
  depends_on "gmp" # std uses it but it's not linked
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "openssl@1.1" # std uses it but it's not linked
  depends_on "pcre"
  depends_on "pkg-config" # @[Link] will use pkg-config if available

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # Every new crystal release is built from the previous one. The exceptions are
  # when crystal make a minor release (only bug fixes). Reason is because those
  # bugs could make the compiler from stopping compiling the next compiler.
  #
  # See: https://github.com/Homebrew/homebrew-core/pull/81318
  resource "boot" do
    on_macos do
      url "https://github.com/crystal-lang/crystal/releases/download/1.3.2/crystal-1.3.2-1-darwin-universal.tar.gz"
      version "1.3.2-1"
      sha256 "ef7c509e29313ad024a54352abc9b9c30269efc2e81c5796b7b64a5f2c68470d"
    end
    on_linux do
      url "https://github.com/crystal-lang/crystal/releases/download/1.3.2/crystal-1.3.2-1-linux-x86_64.tar.gz"
      version "1.3.2-1"
      sha256 "6e102e55d658f2cc0c56d23fcb50bd2edbd98959aa6b59b8e1210c6860651ed4"
    end
  end

  def install
    llvm = deps.find { |dep| dep.name.match?(/^llvm(@\d+)?$/) }
               .to_formula

    (buildpath/"boot").install resource("boot")
    ENV.append_path "PATH", "boot/bin"
    ENV.append_path "CRYSTAL_LIBRARY_PATH", Formula["bdw-gc"].opt_lib
    ENV.append_path "CRYSTAL_LIBRARY_PATH", ENV["HOMEBREW_LIBRARY_PATHS"]
    ENV.append_path "CRYSTAL_LIBRARY_PATH", Formula["libevent"].opt_lib
    ENV.append_path "LLVM_CONFIG", llvm.opt_bin/"llvm-config"

    # Build crystal
    crystal_build_opts = []
    crystal_build_opts << "release=true"
    crystal_build_opts << "FLAGS=--no-debug"
    crystal_build_opts << "CRYSTAL_CONFIG_LIBRARY_PATH="
    crystal_build_opts << "CRYSTAL_CONFIG_BUILD_COMMIT=#{Utils.git_short_head}" if build.head?
    (buildpath/".build").mkpath
    system "make", "deps"
    system "make", "crystal", *crystal_build_opts

    # Build shards (with recently built crystal)
    #
    # Setup the same path the wrapper script would, but just for building shards.
    # NOTE: it seems that the installed crystal in bin/"crystal" can be used while
    #       building the formula. Otherwise this ad-hoc setup could be avoided.
    embedded_crystal_path=`"#{buildpath/".build/crystal"}" env CRYSTAL_PATH`.strip
    ENV["CRYSTAL_PATH"] = "#{embedded_crystal_path}:#{buildpath/"src"}"

    # Install shards
    resource("shards").stage do
      system "make", "bin/shards", "CRYSTAL=#{buildpath/"bin/crystal"}",
                                   "SHARDS=false",
                                   "release=true",
                                   "FLAGS=--no-debug"

      # Install shards
      bin.install "bin/shards"
      man1.install "man/shards.1"
      man5.install "man/shard.yml.5"
    end

    # Install crystal
    libexec.install ".build/crystal"
    (bin/"crystal").write <<~SH
      #!/bin/bash
      EMBEDDED_CRYSTAL_PATH=$("#{libexec/"crystal"}" env CRYSTAL_PATH)
      export CRYSTAL_PATH="${CRYSTAL_PATH:-"$EMBEDDED_CRYSTAL_PATH:#{prefix/"src"}"}"
      export CRYSTAL_LIBRARY_PATH="${CRYSTAL_LIBRARY_PATH:+$CRYSTAL_LIBRARY_PATH:}#{HOMEBREW_PREFIX}/lib"
      export PKG_CONFIG_PATH="${PKG_CONFIG_PATH:+$PKG_CONFIG_PATH:}#{Formula["openssl@1.1"].opt_lib/"pkgconfig"}"
      exec "#{libexec/"crystal"}" "${@}"
    SH

    prefix.install "src"

    bash_completion.install "etc/completion.bash" => "crystal"
    zsh_completion.install "etc/completion.zsh" => "_crystal"

    man1.install "man/crystal.1"
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end
