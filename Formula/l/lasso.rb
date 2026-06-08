class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.9.0.tar.gz"
  sha256 "63816c8219df48cdefeccb1acb35e04014ca6395b5263c70aacd5470ea95c351"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url :homepage
    regex(/href=.*?lasso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d819cfc71c4094c2840f0ace5ec2b01ff6817fe09426d917a47d0c764dc2eccb"
    sha256 cellar: :any,                 arm64_sequoia: "7f6a17ca3f575ee84b0bec14a6ededf285e214cca068e5e6c422ef081f120dc4"
    sha256 cellar: :any,                 arm64_sonoma:  "be4bec7abf0c0303d2e631fe99a257e12df574fa6c1a67aead3b89343cdde66f"
    sha256 cellar: :any,                 sonoma:        "96ead58227b3f791882863b7fcc28967c7827006bfc4ccab9a24a98c8f6a1cca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f40fcc18a21e49380a5f367c2bd82e4cf4f089dd7863238d21c90a199323e777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fc705bad342e13d893469df4786fe35cceab8f3135502723a5218b5458530f8"
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
