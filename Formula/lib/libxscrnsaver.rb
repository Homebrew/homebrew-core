class Libxscrnsaver < Formula
  desc "X.Org: X11 Screen Saver extension client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXScrnSaver-1.2.5.tar.xz"
  sha256 "5057365f847253e0e275871441e10ff7846c8322a5d88e1e187d326de1cd8d00"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6097790285805d792860cbcf0bb663c76b58d51a57d505346b179e52e2f7ce7c"
    sha256 cellar: :any,                 arm64_sequoia: "464b8c95cf2d758476e47dc6f774c6504b84b0265cd458d8fd33619f1386721c"
    sha256 cellar: :any,                 arm64_sonoma:  "5394466712bb2b54879e310768f2fd52ab60d60322a84f80305d23d7c4991c9c"
    sha256 cellar: :any,                 arm64_ventura: "57f870876b14e7f906853fbd220817b7cc74873e2310bc5bfca0af2ce15c3279"
    sha256 cellar: :any,                 sonoma:        "c28763bc9642f615b6aa7864a720dc4b1c6a66875cd23d984c7df896dd515837"
    sha256 cellar: :any,                 ventura:       "b792a3c4125f99032104d8154eaa3c47296d09bc3c973e88a9dca6288fad6d49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c1321270199c8288dc9a1b946e542fe379cc1ca0ee5132d956b7ce6a7c33d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "592204a7c4aa929e51c550213e52af404a62e1e83075d48daa93e8efb9a88e36"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "xorgproto"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/extensions/scrnsaver.h"

      int main(int argc, char* argv[]) {
        XScreenSaverNotifyEvent event;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
