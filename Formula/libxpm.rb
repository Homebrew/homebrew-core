class Libxpm < Formula
  desc "X.Org: X Pixmap (XPM) image file format library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXpm-3.5.13.tar.bz2"
  sha256 "9cd1da57588b6cb71450eff2273ef6b657537a9ac4d02d0014228845b935ac25"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8b1e709e3a1c65e21f58ab2f43174c67a1528aeaabac6af88de7818c3ed46f34"
    sha256 cellar: :any,                 arm64_big_sur:  "a776d9437e8557afeb4dd8e1e91e439ff049df1d8d256af9c34be49843ef7591"
    sha256 cellar: :any,                 monterey:       "4e4ffef5d95c5ef0e30408c1b00aebc0455fa08fc77e5158bcf326b4a1cbcb2e"
    sha256 cellar: :any,                 big_sur:        "484557bf3ce403fc097a70127b9db08cbed9b39372263493588e1539b60ac631"
    sha256 cellar: :any,                 catalina:       "fbd3f2bbf058c081bd35672c0129a33efa38b7e599726be145d0b8b818549516"
    sha256 cellar: :any,                 mojave:         "c3f788d5e8d2f0ec940af7c758acc0efce194cf526b19ab64bdeaba55e1b6793"
    sha256 cellar: :any,                 high_sierra:    "72d7dc1306010048b85b9070287e8c9d5f5a24308b1a413080a4e129aa9bcc0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd04dae0697e928535158273fb70b168c732b84d395ffd28f5a47835fc9bf536"
  end

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libx11"

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
      #include "X11/xpm.h"

      int main(int argc, char* argv[]) {
        XpmColor color;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
