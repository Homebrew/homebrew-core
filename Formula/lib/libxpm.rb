class Libxpm < Formula
  desc "X.Org: X Pixmap (XPM) image file format library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXpm-3.5.17.tar.gz"
  sha256 "959466c7dfcfcaa8a65055bfc311f74d4c43d9257900f85ab042604d286df0c6"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "7f32f5d6061fb478a3ea39d4c36464e5a26a777d25fd6ac2be014ecedd7050e3"
    sha256 cellar: :any,                 arm64_sequoia:  "a78b3654640de7665b01b2b6e61420a85bba28185aeb13c71677690c558c8c42"
    sha256 cellar: :any,                 arm64_sonoma:   "4e515c10ad6f503a64cbc95c7bded77018f3f9ff5c7edd27f6a1eead7f7152b5"
    sha256 cellar: :any,                 arm64_ventura:  "eaf7ccf963015adb96b81535ddd9b843bde2f1f2d558e737ff88da4f559b5918"
    sha256 cellar: :any,                 arm64_monterey: "c502e241aa5021ec70a444fd268bbf7b55ad4c6a5495b13828c3511ad36cdf9a"
    sha256 cellar: :any,                 sonoma:         "f46993627dccbd01bf4efbef9bd6bcaa6201dd3ed95845f36d761ac3a6005ad2"
    sha256 cellar: :any,                 ventura:        "b77cec2defe44c7188d60411cb02ff6c04294c01040d28ff52e449196e4bfd72"
    sha256 cellar: :any,                 monterey:       "8876141eb41e3bef55d16ec8a792c328c942fa65556ace6f61fe04eb3a998305"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e44e847b442ad8deda39fe1ce156886a012efec2905091c3cd058fedf43c905b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42c491e24ddc28e4663b4f630486564c913238fe77b8ca81bb6cfc6758bf715c"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "libx11"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-open-zfile
      --disable-silent-rules
      --disable-stat-zfile
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/Xlib.h"
      #include "X11/xpm.h"

      int main(int argc, char* argv[]) {
        XpmColor color;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
