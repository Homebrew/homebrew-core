class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"
  license "Apache-2.0"
  revision 1

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.36.1.tar.gz"
    sha256 "e6806aa04f60dfe0aaf3cfef103e252f6ac3d8400ea3305b0d1b8463b052ec88"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.13.0.tar.gz"
      sha256 "82a496aa450624afceab79bd9f7e6e1a43de41f61095512d08c3a3063c4da723"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "6a67b2d0d6126a9e7efd6c07f31259fad939b8eac6a5a7034f3ce3ff50983186"
    sha256 cellar: :any, catalina: "5616e5a4912379b079cf5320e6d7c0d5e8eef4c3f8678abdd355c8943fe9dbec"
    sha256 cellar: :any, mojave:   "1bc2fd90e92959405025638b5a7f7b3b8f5d1131ae62fa56d8557e7f27a94b27"
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

  resource "boot" do
    on_macos do
      url "https://github.com/crystal-lang/crystal/releases/download/0.35.1/crystal-0.35.1-1-darwin-x86_64.tar.gz"
      version "0.35.1-1"
      sha256 "7d75f70650900fa9f1ef932779bc23f79a199427c4219204fa9e221c330a1ab6"
    end
    on_linux do
      url "https://github.com/crystal-lang/crystal/releases/download/0.35.1/crystal-0.35.1-1-linux-x86_64.tar.gz"
      version "0.35.1-1"
      sha256 "6c3fd36073b32907301b0a9aeafd7c8d3e9b9ba6e424ae91ba0c5106dc23f7f9"
    end
  end

  def install
    (buildpath/"boot").install resource("boot")
    ENV.append_path "PATH", "boot/bin"

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
    ENV["CRYSTAL_LIBRARY_PATH"] = ENV["HOMEBREW_LIBRARY_PATHS"]

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
