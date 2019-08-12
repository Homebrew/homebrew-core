class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.30.1.tar.gz"
    sha256 "0ffc00fa54929c2533bc0bcb89e0b001dd3abc470ccc87e3576047a5cdafc062"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.8.1.tar.gz"
      sha256 "75c74ab6acf2d5c59f61a7efd3bbc3c4b1d65217f910340cb818ebf5233207a5"
    end
  end

  bottle do
    sha256 "ac0546fa966cd4176d2c576695d7fcbea19c5bc9e8cd3e6dbfb2a75bf7733bc0" => :mojave
    sha256 "09738d66de81fbce00369059c6ae923d7ecf4af3b6485dbbda406a1a9ef2729f" => :high_sierra
    sha256 "2df6377ed86114d1fd5821430d2835ba91fccdafbf593c3a95099e7f66d95547" => :sierra
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
    url "https://github.com/crystal-lang/crystal/releases/download/0.29.0/crystal-0.29.0-1-darwin-x86_64.tar.gz"
    version "0.29.0-1"
    sha256 "6de700d88dc0486c0d56e4d5c6852dc675256aa6f2c571ed8e4b15e0fc72a0b9"
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
