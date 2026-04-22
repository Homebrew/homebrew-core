class Hercules < Formula
  desc "System/370, ESA/390 and z/Architecture Emulator"
  homepage "https://sdl-hercules-390.github.io/html/"
  url "https://github.com/SDL-Hercules-390/hyperion/archive/refs/tags/Release_4.9.1.tar.gz"
  sha256 "22768fee6a949c31fed075886dffc7d81ac89ffc3d2f5cb2fc971e71be1c22a7"
  license "QPL-1.0"
  head "https://github.com/SDL-Hercules-390/hyperion.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "c39ccead16433acc00edfe54721fc9354225596901556828b5771ba04dfb0826"
    sha256 arm64_sequoia: "d6bf59da64af8e0c785e00a0dd9650079d6a947889a2a6ad11f0db47c095187e"
    sha256 arm64_sonoma:  "2cb5be7faa77bc9a7f76f183af1c091fac9a34cb062dbf17a17295ecf9c3fd2a"
    sha256 sonoma:        "50c7c08f9bb643baed46c414771177597cdb56bffccc4c1f9530a0f04bd17092"
    sha256 arm64_linux:   "7a503644a4ecf23cbf89b23b5fdecd14bff658578b4c86c8dfa302e7752cccdc"
    sha256 x86_64_linux:  "4d13a5a101f408a41ea50a649a38cf8bf768050dc563f6006a26e3fa971cd8ee"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "gnu-sed" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
