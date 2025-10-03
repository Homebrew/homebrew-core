class Libxcomposite < Formula
  desc "X.Org: Client library for the Composite extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXcomposite-0.4.6.tar.xz"
  sha256 "fe40bcf0ae1a09070eba24088a5eb9810efe57453779ec1e20a55080c6dc2c87"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "3ee0f26be9958822329e6756d778a36662369d7fe306772a01a5354a6f1af924"
    sha256 cellar: :any,                 arm64_sequoia:  "da32d7ca9d60bea76c4c75ac3ac601601794a44689b7e7ecd0bb076730516202"
    sha256 cellar: :any,                 arm64_sonoma:   "5bb05841f68025cbe9d0db5f308f1065025a1ee118a6f8b9796774f936a518e1"
    sha256 cellar: :any,                 arm64_ventura:  "b0c612dfb969ecf35178c2182cd9fcc5f9506ec3f31f7b1960daccf5765966be"
    sha256 cellar: :any,                 arm64_monterey: "9b0e2df221f534feb43981325bcf9a76b1842568e334b5b39e1e05a62e151be8"
    sha256 cellar: :any,                 arm64_big_sur:  "a9364f8f327cc0144f76c882b229594ff98f2116cbb70e47f67d719b9bec95d2"
    sha256 cellar: :any,                 sonoma:         "40e34f114bbdb3d709ea6fffd38cd116b6885dd12167f1011315f26ac45f61ad"
    sha256 cellar: :any,                 ventura:        "265fe93f675ddff1bafadf967d0e94ad661353212f3174509c045886d66b65bd"
    sha256 cellar: :any,                 monterey:       "e432a0fafe63d5d8273cf9c5610affa3aee679c2957563baac21a6b40cf79741"
    sha256 cellar: :any,                 big_sur:        "f3a01d95abda49871f6889677281038dfcf96bef7c12655a0d0f51b9dcebf363"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1e082d9e46db22cb5694fa3f84e992eb59e3ae08921b0ee479f0cf7eef3b46d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c6925de51a563c4385b69861aef8eb8cd7cb7982dcbb4a2f4d8395728b2ffea"
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
