class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.35.0.tar.gz"
    sha256 "9281afe3bee8cffff5d3aa32e66ed2129946893fe65a3791f3f27b5b13abc006"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.11.1.tar.gz"
      sha256 "e78095867334b4058f860c6da8dc3892994769ef51795de74ffb708a66c6847d"
    end
  end

  bottle do
    cellar :any
    sha256 "0d5901c5cd88efa6ea70edd375cc6838435c54a520fca6a5457f60f869acb1da" => :catalina
    sha256 "bd5c2056860edf33395c89f30a89a69b0819a6bf2741fa724e96602ccf16a645" => :mojave
    sha256 "2c596258ff743cbf5fd1dfca86b23c6d62062ab59cbb4e0ff5c2184fce1c2a75" => :high_sierra
  end

  head do
    url "https://github.com/crystal-lang/crystal.git"

    resource "shards" do
      url "https://github.com/crystal-lang/shards.git"
    end
  end

  depends_on "autoconf"      => :build # for building bdw-gc
  depends_on "automake"      => :build # for building bdw-gc
  depends_on "libatomic_ops" => :build # for building bdw-gc
  depends_on "libtool"       => :build # for building bdw-gc

  depends_on "gmp" # std uses it but it's not linked
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "openssl@1.1" # std uses it but it's not linked
  depends_on "pcre"
  depends_on "pkg-config" # @[Link] will use pkg-config if available

  # Crystal uses an extended version of bdw-gc to handle multi-threading
  resource "bdw-gc" do
    url "https://github.com/ivmai/bdwgc/releases/download/v8.0.4/gc-8.0.4.tar.gz"
    sha256 "436a0ddc67b1ac0b0405b61a9675bca9e075c8156f4debd1d06f3a56c7cd289d"

    # extension to handle multi-threading
    patch :p1 do
      url "https://github.com/ivmai/bdwgc/commit/5668de71107022a316ee967162bc16c10754b9ce.patch?full_index=1"
      sha256 "5c42d4b37cf4997bb6af3f9b00f5513644e1287c322607dc980a1955a09246e3"
    end
  end

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.34.0/crystal-0.34.0-1-darwin-x86_64.tar.gz"
    version "0.34.0-1"
    sha256 "979b3006b03e5c598deb0c5a519b7fc9c5a805c930416b77b492a28af0a3a972"
  end

  def install
    (buildpath/"boot").install resource("boot")
    ENV.append_path "PATH", "boot/bin"

    resource("bdw-gc").stage(buildpath/"gc")
    cd(buildpath/"gc") do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-shared",
                            "--enable-large-config"
      system "make"
    end

    # Build crystal
    crystal_build_opts = []
    crystal_build_opts << "release=true"
    crystal_build_opts << "FLAGS=--no-debug"
    crystal_build_opts << "CRYSTAL_CONFIG_LIBRARY_PATH="
    if build.head?
      crystal_build_opts << "CRYSTAL_CONFIG_BUILD_COMMIT=#{Utils.safe_popen_read("git rev-parse --short HEAD").strip}"
    end
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
    ENV["CRYSTAL_LIBRARY_PATH"] = buildpath/"gc/.libs"

    # Install shards
    resource("shards").stage do
      ENV["CRYSTAL_OPTS"] = "--release --no-debug"
      system "make", "bin/shards", "CRYSTAL=#{buildpath/"bin/crystal"}",
                                   "SHARDS=#{buildpath/"boot/embedded/bin/shards"}"

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
      export CRYSTAL_LIBRARY_PATH="${CRYSTAL_LIBRARY_PATH:+$CRYSTAL_LIBRARY_PATH:}#{prefix/"embedded/lib"}:/usr/lib:/usr/local/lib"
      export PKG_CONFIG_PATH="${PKG_CONFIG_PATH:+$PKG_CONFIG_PATH:}#{Formula["openssl"].opt_lib/"pkgconfig"}"
      exec "#{libexec/"crystal"}" "${@}"
    SH

    prefix.install "src"
    (prefix/"embedded/lib").install "#{buildpath/"gc"}/.libs/libgc.a"

    bash_completion.install "etc/completion.bash" => "crystal"
    zsh_completion.install "etc/completion.zsh" => "_crystal"

    man1.install "man/crystal.1"
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end
