class Libxcomposite < Formula
  desc "X.Org: Client library for the Composite extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXcomposite-0.4.7.tar.xz"
  sha256 "8bdf310967f484503fa51714cf97bff0723d9b673e0eecbf92b3f97c060c8ccb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b9f78b5015dff6cf0f0e3502d5bb1b68554762c5a99c42f42a4df3eb1332993c"
    sha256 cellar: :any,                 arm64_sequoia: "44930f02849b36b984f59a7f54e7a6e30a0c68bdb161ade3489c85da3add1f92"
    sha256 cellar: :any,                 arm64_sonoma:  "39186e194080cfaf90cf095df02c8b9e12dfefadc3ae011c536111cbc0b6bf6f"
    sha256 cellar: :any,                 sonoma:        "bd0f533e1472d808217fe6b8e2eb5e79fcd7304ed0160c18132450aa1dc052f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4abdd9cbed5a4afcadec1d342113f314330492dab6192c68023b2d323d9dde2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8315c74c0801195039af20cb91211b9966bdf7541b895794146ec4d50ac55e46"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxfixes"
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
      #include "X11/Xlib.h"
      #include "X11/extensions/Xcomposite.h"

      int main(int argc, char* argv[]) {
        Display *d = NULL;
        int s = DefaultScreen(d);
        Window root = RootWindow(d, s);
        XCompositeReleaseOverlayWindow(d, s);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lXcomposite"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
