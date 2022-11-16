class Libxvmc < Formula
  desc "X.Org: X-Video Motion Compensation API"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXvMC-1.0.13.tar.xz"
  sha256 "0a9ebe6dea7888a747e5aca1b891d53cd7d3a5f141a9645f77d9b6a12cee657c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7c86347af3f1470259af400e6679dcb45030a98a331cb377a42ac906baf53a78"
    sha256 cellar: :any,                 arm64_monterey: "8dd27f8a1dfc1d9d1a8de409a18365eda5ac632f1e07a25489cc49074076f552"
    sha256 cellar: :any,                 arm64_big_sur:  "1f3cbc8fdb6acd20a304917bd4bd4ac4f8e8d9ab3cecb94f2a0dc63e59e63f41"
    sha256 cellar: :any,                 ventura:        "76f89fdba70b76925009020bd8ba4c806d49ca5c624ccfb4eca46383cf3339a4"
    sha256 cellar: :any,                 monterey:       "d4aa0e1d0640d0508c623c22c8d3818f5fa58eda8f64fbc0863b21b318b40e55"
    sha256 cellar: :any,                 big_sur:        "22eb48198116b542d5c038d83acadf2eaf7354ba68bb3d5ec147172d6bf776a2"
    sha256 cellar: :any,                 catalina:       "e6ccee73e8041296f51cfea28b2f5a3f3800611df6364605827240190d5c8752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f82dbdd0f31764d35dc28ab31057bed67d0eb38610f7d6158ecfdb201af1411"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxv"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xlib.h"
      #include "X11/extensions/XvMClib.h"

      int main(int argc, char* argv[]) {
        XvPortID *port_id;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
