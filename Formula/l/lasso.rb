class Lasso < Formula
  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.9.0.tar.gz"
  sha256 "63816c8219df48cdefeccb1acb35e04014ca6395b5263c70aacd5470ea95c351"
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url :homepage
    regex(/href=.*?lasso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5d3ebb00f5c69dd34e0ef83f7e187a516e4ea95d22baf5bad619bc405ba58fad"
    sha256 cellar: :any, arm64_sequoia: "7aba86db992744b105a640fc7f33ce53787c21ff54c3b458a93e81fd426a3de3"
    sha256 cellar: :any, arm64_sonoma:  "ae12ac63e8e0010cc75805efda37b58ad974a9fd41a06bd3a980f9d1030e1161"
    sha256 cellar: :any, sonoma:        "5cd4ecdb2b5f34302ddb1cd260626f55c7d68c9187c75fce0015209184cbeb5a"
    sha256 cellar: :any, arm64_linux:   "cd3f506a6563d5a9f26ce8da89c3d15a90bb3d3e2d0a0747239ee8500d1c5654"
    sha256 cellar: :any, x86_64_linux:  "1b6ccf011635fb26703751fb25e921fdb2f24e332bc6ae75002cee83320f4b94"
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
