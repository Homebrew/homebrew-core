class IsaL < Formula
  desc "Intelligent Storage Acceleration Library"
  homepage "https://github.com/intel/isa-l"
  url "https://github.com/intel/isa-l/archive/refs/tags/v2.32.0.tar.gz"
  sha256 "7a194ff80d0f7e20615c497654e8a51b0184d0c79e2e265c7f555f52a26a05a4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c9267dff7be4ba1ab091dbda0b4b03357c137065c7cddce74d805db366cdd30"
    sha256 cellar: :any,                 arm64_sequoia: "e019082d409dc6dd43f75fdeb61cb292a3aeef8f75b717fabbb99b1af3a09958"
    sha256 cellar: :any,                 arm64_sonoma:  "b07dd2b0b39495e6761ea12b1ed3825fb9955e1ab980f750387b01c530b98e38"
    sha256 cellar: :any,                 sonoma:        "290936d5a39f56f7fa037847e8f54eff05714e914851ee58ebe741a507d699b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af4547348a1e1f584e886ac9c916f4591d864c41a5ae6e6954b59fe8cbd0fea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0818c2fe4f428cd02da5375231cf7e7cdd859fc47eb834ec8e4f0e51243e402"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
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
