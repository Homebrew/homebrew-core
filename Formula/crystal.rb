class Crystal < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "https://crystal-lang.org/"

  stable do
    url "https://github.com/crystal-lang/crystal/archive/0.28.0.tar.gz"
    sha256 "4206f57c6345454504ec4cd8cbd1b9354b9be29fae4cdcdd173f4a28cc13b102"

    resource "shards" do
      url "https://github.com/crystal-lang/shards/archive/v0.8.1.tar.gz"
      sha256 "75c74ab6acf2d5c59f61a7efd3bbc3c4b1d65217f910340cb818ebf5233207a5"
    end
  end

  bottle do
    sha256 "131fc2303d2f15e46f3c928487ed64bf0d139cb3deb64fe9ff25c0df886f4101" => :mojave
    sha256 "1189ba40af5f99c898361112a0c393bf5ca98f2cb1ac01e0d75edaf44ed12fee" => :high_sierra
    sha256 "e9ced10a0d2b3e5a4d19b8f1c6dc84c432abddfbc380317c4d1ddd6bec6be4c4" => :sierra
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
  depends_on "llvm@6"
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
    url "https://github.com/crystal-lang/crystal/releases/download/0.27.2/crystal-0.27.2-1-darwin-x86_64.tar.gz"
    version "0.27.2-1"
    sha256 "2fcd11a3c3d12176004c13aa90d8ca15acde7d1ffa9a82cbaadcd526984a8691"
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

    # TODO: in 0.29.0 this can be replaced with CRYSTAL_LIBRARY_PATH
    #       in order to build the compiler binary with a static libgc.a
    ENV.prepend_path "PKG_CONFIG_PATH", buildpath
    (buildpath/"gc.pc").write <<~EOS
      Name: bdwgc
      Description:
      Version: 8.0.4+mt
      Libs: #{buildpath/"gc"}/.libs/libgc.a
    EOS

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
      system buildpath/"bin/crystal", "build", "-o", buildpath/".build/shards", "src/shards.cr"
    end

    bin.install ".build/shards"
    bin.install ".build/crystal"
    prefix.install "src"
    (prefix/"embedded/lib").install "#{buildpath/"gc"}/.libs/libgc.a"

    bash_completion.install "etc/completion.bash" => "crystal"
    zsh_completion.install "etc/completion.zsh" => "_crystal"
  end

  test do
    assert_match "1", shell_output("#{bin}/crystal eval puts 1")
  end
end
