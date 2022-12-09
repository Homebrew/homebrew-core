class Libice < Formula
  desc "X.Org: Inter-Client Exchange Library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libICE-1.1.1.tar.xz"
  sha256 "03e77afaf72942c7ac02ccebb19034e6e20f456dcf8dddadfeb572aa5ad3e451"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fa2c5df01e83c86a5130826e0bf9b9752d8882d135a3b5c690b97d43158e5d89"
    sha256 cellar: :any,                 arm64_monterey: "cbbaa9a97687b280ea61a3495f1aefc45f23f646dc3e5fced4a5e2ae21b81770"
    sha256 cellar: :any,                 arm64_big_sur:  "87b827a30308818f51d001943f240161c528603a5d28f925f53a3a2b8962a375"
    sha256 cellar: :any,                 ventura:        "bf5ceabea0dcac1840788fd7a3c59177691795fecbc26a0fbf27be41d0ca6447"
    sha256 cellar: :any,                 monterey:       "e8efaecd284e34f63f62014a4994b038f278cfa98c464516b79a3c8777c784d2"
    sha256 cellar: :any,                 big_sur:        "849e7928d4ec633c0f043474f2461850e16ee37d2d2c222e4515999c4db7f4c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb765b7d87b1d54755316332ce323bfe222c76a327a686e9fbc4b6b395ce9d97"
  end

  depends_on "pkg-config" => :build
  depends_on "xtrans" => :build
  depends_on "libx11"=> :test
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-docs=no
      --enable-specs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xlib.h"
      #include "X11/ICE/ICEutil.h"

      int main(int argc, char* argv[]) {
        IceAuthFileEntry entry;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
