class Libxres < Formula
  desc "X.Org: X-Resource extension client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXres-1.2.3.tar.xz"
  sha256 "d2de8f5401d6c86a8992791654547eb8def585dfdc0c08cc16e24ef6aeeb69dc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee5ef314b15e82ed7df2d475d90f1d899423f25d8a189bd1f59ceef05363c2b2"
    sha256 cellar: :any,                 arm64_sequoia: "2873727dfba77ea52eefb1473655932f9e8ce0fa62ced56d031c614f9e779dd5"
    sha256 cellar: :any,                 arm64_sonoma:  "357d86dcc9d3cbb4f7449954590a527744802b126cc92aedd35e66bfc608234b"
    sha256 cellar: :any,                 arm64_ventura: "a903e212d5d0b4cdb66bf9f6c18102c0ad42abfe4901b125b313545b37543a7c"
    sha256 cellar: :any,                 sonoma:        "2422ab6e030e4e0b6bd8ab9b79aef44c053f9d8efd44f2da8dfedc2eecc32ebd"
    sha256 cellar: :any,                 ventura:       "dd24c683589a44399963c6d87e671f258ebca3efb0a393c8ce5616ea7e19378d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95deabb73d93e6d1db9e9fb6e08d5eeb969caa6e578b082a515c0a55b67658c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8682132f7c2d181729a89346cc24cfe9f1dac6133cd197efa17b759775194ecd"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build
  depends_on "libx11"
  depends_on "libxext"

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
      #include "X11/Xlib.h"
      #include "X11/extensions/XRes.h"

      int main(int argc, char* argv[]) {
        XResType client;
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lXRes"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
