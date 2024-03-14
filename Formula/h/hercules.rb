class Hercules < Formula
  desc "System/370, ESA/390 and z/Architecture Emulator"
  homepage "https://sdl-hercules-390.github.io/html/"
  url "https://github.com/SDL-Hercules-390/hyperion/archive/refs/tags/Release_4.7.tar.gz"
  sha256 "74c747773e0b5639164f6f69ce9220e1bd1d4853c5c4f18329da21c03aebe388"
  license "QPL-1.0"
  head "https://github.com/SDL-Hercules-390/hyperion.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "68878f114b2f527152e73c11c8dfdf8f4b449ad1bdd98e2cce203d11d6eab59e"
    sha256 arm64_ventura:  "9fcd456bb4ae3b312765e3b0c2c3d10a3d24aab9d2d39745b7bb049b08d1dd35"
    sha256 arm64_monterey: "989fec41881653b8d1f7372d4de8447703fba4b2b6880194e5974cdad50b58d9"
    sha256 arm64_big_sur:  "ba4b3fa347d63601909127c94c0a2b1e42d81bbcc154970a18d7dd4ad8b15bba"
    sha256 sonoma:         "e7ff4c56c22896aab1caa013a28885b8c59654904c97f24713a64ca9102a990c"
    sha256 ventura:        "478ecb96c865328760fd636aee98d44e0b5f27e90be83d3fef3c0f437d41830e"
    sha256 monterey:       "00df43bff8324b015c01c6cae809d69b911e2c2ba45b0a07a4d3be440daf672b"
    sha256 big_sur:        "c85d96adaa0f5cc5a17d5927d4cd1b44f42003baba3e59ff11cee5ce444512fc"
    sha256 catalina:       "aae09d5616cf146c74bf3bfae69c1490cf920404d75d43c7d8c28ac1aab176b8"
    sha256 mojave:         "3c7535fa1d1e9385c9f2525e40445b931c3768ab611db4e6a2019c7910538c41"
    sha256 x86_64_linux:   "253d9c36ec65a956796d413a957999b99bc22b10fc3baa436f2d3fb7ef7dcd25"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "gnu-sed" => :build
  depends_on "libtool" => :build
  uses_from_macos "zlib"

  resource "crypto" do
    url "https://github.com/SDL-Hercules-390/crypto/archive/a5096e5dd79f46b568806240c0824cd8cb2fcda2.tar.gz"
    sha256 "78bda462d46c75ab4a92e7fd6755b648658851f5f1ac3f07423e55251bd83a8c"
  end

  resource "decNumber" do
    url "https://github.com/SDL-Hercules-390/decNumber/archive/3aa2f4531b5fcbd0478ecbaf72ccc47079c67280.tar.gz"
    sha256 "527192832f191454b19da953d1f3324c11a4f01770ad2451c42dc6d638baca62"
  end

  resource "SoftFloat" do
    url "https://github.com/SDL-Hercules-390/SoftFloat/archive/4b0c326008e174610969c92e69178939ed80653d.tar.gz"
    sha256 "46a141a183cb1ad8de937612d134ad51e8ff100931bcf6d4a62874baadf18e69"
  end

  resource "telnet" do
    url "https://github.com/SDL-Hercules-390/telnet/archive/729f0b688c1426018112c1e509f207fb5f266efa.tar.gz"
    sha256 "222bc9c5b56056b3fa4afdf4dd78ab1c87673c26c725309b1b3a6fd3e0e88d51"
  end

  def install
    resources.each do |r|
      resource_prefix = buildpath/r.name
      resource_prefix.rmtree
      build_dir = buildpath/"#{r.name}64.Release"

      r.stage do
        system "cmake", "-S", ".", "-B", build_dir, *std_cmake_args(install_prefix: resource_prefix)
        system "cmake", "--build", build_dir
        system "cmake", "--install", build_dir
      end

      (resource_prefix/"lib/aarch64").install_symlink (resource_prefix/"lib").children if Hardware::CPU.arm?
    end

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-optimization=no",
                          "--disable-getoptwrapper",
                          "--without-included-ltdl"
    system "make"
    ENV.deparallelize if OS.linux?
    system "make", "install"
    pkgshare.install "hercules.cnf"
  end

  test do
    (testpath/"test00.ctl").write <<~EOS
      TEST00 3390 10
      TEST.PDS EMPTY CYL 1 0 5 PO FB 80 6080
    EOS
    system "#{bin}/dasdload", "test00.ctl", "test00.ckd"
  end
end
