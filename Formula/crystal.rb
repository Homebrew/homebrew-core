class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.31.0.tar.gz"
    sha256 "483ffcdce30b98f89b8c6cf6e48c62652cd0450205f609e04721a37997c32486"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.8.1.tar.gz"
      sha256 "75c74ab6acf2d5c59f61a7efd3bbc3c4b1d65217f910340cb818ebf5233207a5"
    end
  end

  bottle do
    sha256 "3e6d1c482c1d4128b7298e63219ae1ea311d4575c3f0f6791b44e60ce7f7d2d6" => :mojave
    sha256 "3a2a303378a72dccc017092c6aed04de81b3f8bf56b654b568f9e2fa56c16a7a" => :high_sierra
    sha256 "b810c431c44ab0ca75af43d461ed21706065eac5c2a9ab95ff491a745db0e464" => :sierra
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
  depends_on "pcre"
  depends_on "pkg-config" # @[Link] will use pkg-config if available

  # Crystal uses an extended version of bdw-gc to handle multi-threading
  resource "bdw-gc" do
    url "https://github.com/ivmai/bdwgc/releases/download/v8.0.4/gc-8.0.4.tar.gz"
    sha256 "436a0ddc67b1ac0b0405b61a9675bca9e075c8156f4debd1d06f3a56c7cd289d"

    # extension to handle multi-threading
    patch :p1 do
      url "https://raw.githubusercontent.com/crystal-lang/distribution-scripts/ab683792f34c60159f0e697adf792ff5b0fcbf91/linux/files/feature-thread-stackbottom.patch"
      sha256 "acbae8cfe10e3efac403a629490cfd05e809554d23e9c3a88acddbb66f8ef7e0"
    end
  end

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.30.1/crystal-0.30.1-1-darwin-x86_64.tar.gz"
    version "0.30.1-1"
    sha256 "ffc3ee9124367a2dcd76f9b4c2bf8df083ba8fce506aaf0e3c6bfad738257adc"
  end

  def install
    (buildpath/"boot").install resource("boot")

    if build.head?
      ENV["CRYSTAL_CONFIG_BUILD_COMMIT"] = Utils.popen_read("git rev-parse --short HEAD").strip
    end

    ENV["CRYSTAL_CONFIG_PATH"] = prefix/"src:lib"
    ENV["CRYSTAL_CONFIG_LIBRARY_PATH"] = prefix/"embedded/lib"
    ENV.append_path "PATH", "boot/bin"

    resource("bdw-gc").stage(buildpath/"gc")
    cd(buildpath/"gc") do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-shared",
                            "--enable-large-config"
      system "make"
    end

    ENV.prepend_path "CRYSTAL_LIBRARY_PATH", buildpath/"gc/.libs"

    # Build crystal
    (buildpath/".build").mkpath
    system "make", "deps"
    system "bin/crystal", "build",
                          "-D", "without_openssl",
                          "-D", "without_zlib",
                          "-D", "preview_overflow",
                          "-o", ".build/crystal",
                          "src/compiler/crystal.cr",
                          "--release", "--no-debug"

    # Build shards
    resource("shards").stage do
      system buildpath/"bin/crystal", "build",
                                      "-o", buildpath/".build/shards",
                                      "src/shards.cr",
                                      "--release", "--no-debug"

      man1.install "man/shards.1"
      man5.install "man/shard.yml.5"
    end

    bin.install ".build/shards"
    bin.install ".build/crystal"
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
