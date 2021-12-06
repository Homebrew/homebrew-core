class IsaL < Formula
  desc "Intelligent Storage Acceleration Library"
  homepage "https://github.com/intel/isa-l"
  url "https://github.com/intel/isa-l/archive/refs/tags/v2.30.0.tar.gz"
  sha256 "bcf592c04fdfa19e723d2adf53d3e0f4efd5b956bb618fed54a1108d76a6eb56"
  license "BSD-3-Clause"

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
