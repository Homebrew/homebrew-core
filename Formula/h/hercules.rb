class Hercules < Formula
  desc "System/370, ESA/390 and z/Architecture Emulator"
  homepage "https://sdl-hercules-390.github.io/html/"
  url "https://github.com/SDL-Hercules-390/hyperion/archive/refs/tags/Release_4.9.tar.gz"
  sha256 "a4ace85ee03c222d8885e7f54d767c2c7d9dc491c2bb0eb47c7b948c9c58fdd6"
  license "QPL-1.0"
  head "https://github.com/SDL-Hercules-390/hyperion.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "ad5888268b551257777c5d2c56c432599c05bee7e8c4a66f2f5081e9d1514de7"
    sha256 arm64_sequoia: "0e281826448d5def0056f65d546b5f59fec18f05ec229043497d0fe78b7b9c57"
    sha256 arm64_sonoma:  "561b7b6c87204d6206ac9d00c5803da3f851060db460bd0cd36c22bddea664f4"
    sha256 sonoma:        "acdb71437a635d2d279ac7d5536e763cfff952b85ff9d742c1163f8c5c2f00fb"
    sha256 arm64_linux:   "4199092ee89b5a565149f4f1b13aa4d1eceaf62c1afc77b8244bd0415abf566b"
    sha256 x86_64_linux:  "7deb319117d5197e431ab89d7266f750fbe5b40f9c7319d1138a77f957707149"
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

    # Workaround for CMake 4 compatibility
    patch do
      url "https://github.com/SDL-Hercules-390/crypto/commit/9ac58405c2b91fb7cd230aed474dc7059f0fcad9.patch?full_index=1"
      sha256 "e650ed22fb63ec7d87c0dd79ec6f98ea4988e7635a8add13c8149d0731826710"
    end
  end

  resource "decNumber" do
    url "https://github.com/SDL-Hercules-390/decNumber/archive/3aa2f4531b5fcbd0478ecbaf72ccc47079c67280.tar.gz"
    sha256 "527192832f191454b19da953d1f3324c11a4f01770ad2451c42dc6d638baca62"

    # Workaround for CMake 4 compatibility
    patch do
      url "https://github.com/SDL-Hercules-390/decNumber/commit/995184583107625015bb450228a5f3fb781d9502.patch?full_index=1"
      sha256 "4a803caf1841cbb6597c195df3e5287345c35e154d46ac58f33c21b737b1e4b7"
    end
  end

  resource "SoftFloat" do
    url "https://github.com/SDL-Hercules-390/SoftFloat/archive/c114c53e672d92671e0971cfbf8fe2bed3d5ae9e.tar.gz"
    sha256 "3dfbd1c1dc2ee6b1dcc6d67fa831d0590982c28f518ef207363950125d36aa47"

    # Workaround for CMake 4 compatibility
    patch do
      url "https://github.com/SDL-Hercules-390/SoftFloat/commit/e053494d988ec0648c92f683abce52597bfae745.patch?full_index=1"
      sha256 "ac13515baeb9de206d943e6d85fba30ad5f06c058e017161d18edada34aaf203"
    end
  end

  resource "telnet" do
    url "https://github.com/SDL-Hercules-390/telnet/archive/729f0b688c1426018112c1e509f207fb5f266efa.tar.gz"
    sha256 "222bc9c5b56056b3fa4afdf4dd78ab1c87673c26c725309b1b3a6fd3e0e88d51"

    # Workaround for CMake 4 compatibility
    patch do
      url "https://github.com/SDL-Hercules-390/telnet/commit/384b2542dfc9af67ca078e2bc13487a8fc234a3f.patch?full_index=1"
      sha256 "c56109ba2cd9365da690bb13cc5d9d3caaaa8413d800c0bc482482cf02739a01"
    end
  end

  def install
    resources.each do |r|
      resource_prefix = buildpath/r.name
      rm_r(resource_prefix)
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

    system bin/"dasdload", "test00.ctl", "test00.ckd"
  end
end
