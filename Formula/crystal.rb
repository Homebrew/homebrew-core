class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  license "Apache-2.0"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/1.3.1.tar.gz"
    sha256 "64ed3331c91e3d7f1fc7b3d111fc79faf9f7a55a6fdebc2cd8001a5ee93d787b"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.16.0.tar.gz"
      sha256 "e23a51fdcb9747e86b3c58d733a1c7556a78002b46482ca0fdacfe63924dc454"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "9a5ed520c2fc2f8d24f4b2e33df880039a7c8b707269bc24edbf243f542c5984"
    sha256 arm64_big_sur:  "ac117c5c0623b371f89f14ba6d7c3ba2bc1e879593ec464dbe3dad4aa85ac2cb"
    sha256 monterey:       "b74ad477cc11b529de4e6ac0175b360b8b884683131b66a6b6808bc3dd73bd61"
    sha256 big_sur:        "e8c392d10e364a1352bf5c0a7cf4dce7f95867d3943518e84f4b2ec2fc28ba07"
    sha256 catalina:       "4c5743620776c26100dd8b5c6920bf347ba1b541f8a01a532ae543bb35a2e2a8"
    sha256 x86_64_linux:   "ee79e4c60c38c946decbdcdd0d26e391226f8e2426f9524c6517d69b41849bda"
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
  # when crystal make a minor release (only bug fixes). Resason is because those
  # bugs could make the compiler from stopping compiling the next compiler.
  #
  # See: https://github.com/Homebrew/homebrew-core/pull/81318
  resource "boot" do
    on_macos do
      url "https://github.com/crystal-lang/crystal/releases/download/1.2.0/crystal-1.2.0-1-darwin-universal.tar.gz"
      version "1.2.0-1"
      sha256 "ce9e671abec489a95df39e347d109e6a99b7388dffe1942b726cb62e2f433ac3"
    end
    on_linux do
      url "https://github.com/crystal-lang/crystal/releases/download/1.2.2/crystal-1.2.2-1-linux-x86_64.tar.gz"
      version "1.2.2-1"
      sha256 "b16e67862856ffa0e4abde62def24d5acd83d42b5086e8e1c556e040201ab3a1"
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
