class IsaL < Formula
  desc "Intelligent Storage Acceleration Library"
  homepage "https://github.com/intel/isa-l"
  url "https://github.com/intel/isa-l/archive/refs/tags/v2.30.0.tar.gz"
  sha256 "bcf592c04fdfa19e723d2adf53d3e0f4efd5b956bb618fed54a1108d76a6eb56"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 ventura:      "bb6ff29b6adfa19eb203ff666cb45901799fafb92cb92729f4919b7897905ac3"
    sha256 cellar: :any,                 monterey:     "1894e71fbaf5e4d7e10fa7168065f84993eb031ac6da348f898584b23ad8f03c"
    sha256 cellar: :any,                 big_sur:      "ccc29db398c4450a5ae50066d9fe2ae4f3558b19ecf428a4f0fd3caef70256a6"
    sha256 cellar: :any,                 catalina:     "75555d777f620a2a8e69d6e1349027357ebed26ae32b5452b75f46c39d87a934"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "35ef03c3141f36d0e59a8b571dc14cc242407772c7e7b06475d9194745d0898b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  # https://github.com/intel/isa-l/pull/164
  depends_on arch: :x86_64

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/ec/ec_simple_example.c", testpath
    inreplace "ec_simple_example.c", "erasure_code.h", "isa-l.h"
    system ENV.cc, "ec_simple_example.c", "-L#{lib}", "-lisal", "-o", "test"
    assert_match "Pass", shell_output("./test")
  end
end
