class Libxt < Formula
  desc "X.Org: X Toolkit Intrinsics library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXt-1.3.0.tar.xz"
  sha256 "52820b3cdb827d08dc90bdfd1b0022a3ad8919b57a39808b12591973b331bf91"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d73d8d80bcd571049e6989933294d52eedc693a3c8fa8de5f60d127fec7bfc13"
    sha256 cellar: :any,                 arm64_ventura:  "4e3291545ac676d5b024906375b74ba313640031b4e9d3ffb26917aee8b56025"
    sha256 cellar: :any,                 arm64_monterey: "0f000fce8ea72ab0862fe2cbfa50441c891bf4c7203a3a2177b9942740aa906b"
    sha256 cellar: :any,                 arm64_big_sur:  "aee8d6655e268c89ae05625a1a363952ae2940fc85df78e0cecae359cad2c55a"
    sha256 cellar: :any,                 sonoma:         "b554b067cf13b7cabdf9df6badf29c9fc1d4ac91fba87c5e9842b63e8204e2f4"
    sha256 cellar: :any,                 ventura:        "bc30b41126a8ec8f72d11833764191fb4d45dcb0cbf1e427985b0c140a712781"
    sha256 cellar: :any,                 monterey:       "e1763954a423a89d5f6d833914b51ced89e74ada15f533db3433de1073f970e4"
    sha256 cellar: :any,                 big_sur:        "73ec06570a424e3f99fb06cb51db5585b145e3e5a0562664081320ea3f488cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86668ffaa52251771a4490bc843e4317a1b054c4ed3a0add190616f47d70124d"
  end

  depends_on "pkg-config" => :build
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-appdefaultdir=#{etc}/X11/app-defaults
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-specs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/IntrinsicP.h"
      #include "X11/CoreP.h"

      int main(int argc, char* argv[]) {
        CoreClassPart *range;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
