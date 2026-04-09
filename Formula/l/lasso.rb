class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.9.0.tar.gz"
  sha256 "63816c8219df48cdefeccb1acb35e04014ca6395b5263c70aacd5470ea95c351"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?lasso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "41f3d8764b5dc0ddc20ff790a315822f498fd47b646972114b1682be311c1ac8"
    sha256 cellar: :any,                 arm64_sequoia: "707877e266c43b74428031c64e21a41e9d8b734b6648e56f559fca64dbd6696f"
    sha256 cellar: :any,                 arm64_sonoma:  "44ea6bcff874454226d5a9a80326801fdace98b239eded7ef5a09bd649ebedb2"
    sha256 cellar: :any,                 sonoma:        "deb974f63dd6705ab0701cdbe06e09830a69f0f81211ae7e74a23f665a3b2b86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a89fb2481ff5cae631f637e6964666bbe77c849fb534dc6bc21b5bd6e09d3be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e99378cb3aa78496bf60550dd11f893ddc87a02a93426c38cc18f4ed0f7eaea2"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "libxslt"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["PYTHON"] = which("python3")

    system "./configure", "--disable-silent-rules",
                          "--disable-java",
                          "--disable-perl",
                          "--disable-php5",
                          "--disable-php7",
                          "--disable-python",
                          "--with-pkg-config=#{ENV["PKG_CONFIG_PATH"]}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <lasso/lasso.h>

      int main() {
        return lasso_init();
      }
    C
    system ENV.cc, "test.c",
                   "-I#{Formula["glib"].include}/glib-2.0",
                   "-I#{Formula["glib"].lib}/glib-2.0/include",
                   "-I#{Formula["libxml2"].include}/libxml2",
                   "-I#{Formula["libxmlsec1"].include}/xmlsec1",
                   "-L#{lib}", "-llasso", "-o", "test"
    system "./test"
  end
end
