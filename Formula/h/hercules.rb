class Hercules < Formula
  desc "System/370, ESA/390 and z/Architecture Emulator"
  homepage "https://sdl-hercules-390.github.io/html/"
  url "https://github.com/SDL-Hercules-390/hyperion/archive/refs/tags/Release_4.8.tar.gz"
  sha256 "91ac45a1cce8196f32a7d7918db6f935c29a891cd0baedeec70f9290bce91de9"
  license "QPL-1.0"
  head "https://github.com/SDL-Hercules-390/hyperion.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "99d22a70c57b1ef09d2af6f4f1f1836dac37bb9f6a5d4bbb516b78f902bdf770"
    sha256 arm64_sonoma:  "eb8da1cb1281e2d9ba2ca7260d86c28c1b75f79711b6f9f2ec8c956c5556b8c3"
    sha256 arm64_ventura: "4cd0f333e7fb17a5d3e746c7ed3bc6126f2969c9841f7d094afaaa8ac93d6b98"
    sha256 sonoma:        "1551d8fef170befe95c125cd4fb745dc7e694a579d6d7f3d089d0ce50645d77f"
    sha256 ventura:       "1613524057720b523c065d4f8ad567dd0a71414e6dbc59666d65ca341338f518"
    sha256 arm64_linux:   "897a20cdbd2fa6664163911d8a2a47fb972c5879070c83230a268dc6c7390db6"
    sha256 x86_64_linux:  "48bb0bff466cc2f739e49ff0f2eba752986354df6f2848130973e53ad81559a8"
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
    url "https://github.com/SDL-Hercules-390/SoftFloat/archive/c114c53e672d92671e0971cfbf8fe2bed3d5ae9e.tar.gz"
    sha256 "3dfbd1c1dc2ee6b1dcc6d67fa831d0590982c28f518ef207363950125d36aa47"
  end

  resource "telnet" do
    url "https://github.com/SDL-Hercules-390/telnet/archive/729f0b688c1426018112c1e509f207fb5f266efa.tar.gz"
    sha256 "222bc9c5b56056b3fa4afdf4dd78ab1c87673c26c725309b1b3a6fd3e0e88d51"
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
