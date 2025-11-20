class Libxvmc < Formula
  desc "X.Org: X-Video Motion Compensation API"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXvMC-1.0.14.tar.xz"
  sha256 "e4be9eb6b6bafdbbf81f47f7163047215376e45e2dc786d0ea6181c930725ed9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "8e9d6026378f11041d48dbaa055ecbff3b2dd2f21607b1576ccba926ca531448"
    sha256 cellar: :any,                 arm64_sequoia:  "b98800f4d24c2f04f9ac826ed9365195847f7bd3c5aa758abf5ae6c2748256b0"
    sha256 cellar: :any,                 arm64_sonoma:   "ec6119429cbf4d4812c6b9aca9cfd33f1b63802d7536b886f5b4454a55241ecd"
    sha256 cellar: :any,                 arm64_ventura:  "e2990ee70324b5caa16cfb356d2066da14e66c7a9b4ed5c9e5da7867b779d618"
    sha256 cellar: :any,                 arm64_monterey: "7ee479ebc065e0587284e698515087d1f9187ae4b88640d01a333f5d38638d18"
    sha256 cellar: :any,                 sonoma:         "f014a42faf3225b6d7b56c397e7f87a704386e514c86802f04f1351b6d7133e1"
    sha256 cellar: :any,                 ventura:        "06b0927fac5c241e00f13de5a609de3580550e7cfd2088937de8ef3c50fad465"
    sha256 cellar: :any,                 monterey:       "a0bc605754551292b8d475d0dc8dbe35fcb7753385576651601df0a4af9ef690"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f6a849f057352628d93b8b5682b40bf90b196ae1746911f746046f3e79ad665a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bb9249003ad6c7905548d56c1863abf21b9a0f07407139d8060e6a553eff45e"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxv"

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
      #include "X11/extensions/XvMClib.h"

      int main(int argc, char* argv[]) {
        XvPortID *port_id;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
