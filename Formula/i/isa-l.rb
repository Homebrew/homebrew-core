class IsaL < Formula
  desc "Intelligent Storage Acceleration Library"
  homepage "https://github.com/intel/isa-l"
  url "https://github.com/intel/isa-l/archive/refs/tags/v2.31.0.tar.gz"
  sha256 "e218b7b2e241cfb8e8b68f54a6e5eed80968cc387c4b1af03708b54e9fb236f1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 sonoma:       "d8acf795ec2f507feeff18c519b0404efb75f0ce62a0c2bb4beeba7cf708a35c"
    sha256 cellar: :any,                 ventura:      "68a53494a048d922554dfc0875f9e16e48e8887e77428ac940ee262fbd57bc38"
    sha256 cellar: :any,                 monterey:     "6c831c599fd7139b3348a601ce1218390580c5f45d10de10c8fb4ad060c5d776"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b3341f5d86bc61c9de66805c1cd4542622883498f684d622846e6b29d5fced2f"
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
