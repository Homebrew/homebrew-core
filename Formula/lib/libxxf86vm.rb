class Libxxf86vm < Formula
  desc "X.Org: XFree86-VidMode X extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXxf86vm-1.1.6.tar.gz"
  sha256 "d2b4b1ec4eb833efca9981f19ed1078a8a73eed0bb3ca5563b64527ae8021e52"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "863d7125572a3e433f65ee58693b3abb6f7a850524f8d659f7cb903b850f621e"
    sha256 cellar: :any,                 arm64_sequoia: "13c02476485b075f3b74ed0b7e1222f2f9e2abf5b40bfb13aeafde83d3b6a3b9"
    sha256 cellar: :any,                 arm64_sonoma:  "30952396b1e9b0936a4f5e143122bec37cd0b835e26168e4fa87ea0bbc458ab1"
    sha256 cellar: :any,                 arm64_ventura: "363d3b25237b106818012a000ebed92fc21a145c5253c97685801128da9a510b"
    sha256 cellar: :any,                 sonoma:        "0f40e51b6211395733b458f27cb329543cc0c1458217d4bca2bcf2c8b12d1401"
    sha256 cellar: :any,                 ventura:       "75add9e909d354f98af9dc286327692f470fdfd4b32dcd96ea4455adac6e35a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9432dbcf9ae56adcb8735725c1388cc35bcaccef431ac2a78308c1c866f0be24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d916bedfca3e0ba33a43ebc5524d0178fcfd3a6eb95f9b793ca66d8b76d60fb"
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
      #include "X11/Xlib.h"
      #include "X11/extensions/xf86vmode.h"

      int main(int argc, char* argv[]) {
        XF86VidModeModeInfo mode;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
