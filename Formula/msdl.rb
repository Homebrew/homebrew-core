class Msdl < Formula
  desc "Downloader for various streaming protocols"
  homepage "https://msdl.sourceforge.io"
  url "https://downloads.sourceforge.net/project/msdl/msdl/msdl-1.2.7-r2/msdl-1.2.7-r2.tar.gz"
  version "1.2.7-r2"
  sha256 "0297e87bafcab885491b44f71476f5d5bfc648557e7d4ef36961d44dd430a3a1"
  license "GPL-3.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/msdl[._-]v?(\d+(?:\.\d+)+(?:-r\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a22fd7fd9ae5684a10a7646d42a1397b700a31db017be4a40e95ad37ce2d02b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bbb7be167030b97337113482fe1007cf0f48a9fbc343f590b19c9964827e71e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5afd80d5dc62ee3c7a65fe5214d2fe51d89f8eda7ae9bb358bab102f5dd65e6a"
    sha256 cellar: :any_skip_relocation, ventura:        "f2dceb8e2a874043888797e3ad8693aa41babf5c080afe531169ee2fff4e180a"
    sha256 cellar: :any_skip_relocation, monterey:       "f41e17e53c1b292088d9f3160bbba5241b5e467e372c4ae860277038a4daf3e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8703e042137fa27ddbda861bc9e04cea40edb5d3d3c6b4a90f5e850ee01326a"
    sha256 cellar: :any_skip_relocation, catalina:       "71fb71cf2c24085221ee1d24c57fbe07f1b6cc437d84385d22231a4723771207"
    sha256 cellar: :any_skip_relocation, mojave:         "30deed1f7ba83c707aa002a217438e341aae978e27cfc6d39239a063f2b14cde"
    sha256 cellar: :any_skip_relocation, high_sierra:    "5f2922fa4f3b69f3f00cb7e29854c5a43c163e209c87d961253da9c4a7c3ec73"
    sha256 cellar: :any_skip_relocation, sierra:         "69b04b6f10ea552b6c862110434cc63dfa6bfccdc8034edd70fed5db0f79e68b"
    sha256 cellar: :any_skip_relocation, el_capitan:     "34ba320e82d1ce97fb0a106abd2c5ec848ba16857730ba51cadd0a030bee62ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5664cc49f99975d426fab1e8518356d8842512ab773aa4c2a3abe0fb957d1881"
  end

  # Fixes linker error under clang; apparently reported upstream:
  # https://github.com/Homebrew/homebrew/pull/13907
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/src/url.c b/src/url.c
index 81783c7..356883a 100644
--- a/src/url.c
+++ b/src/url.c
@@ -266,7 +266,7 @@ void url_unescape_string(char *dst,char *src)
 /*
  * return true if 'c' is valid url character
  */
-inline int is_url_valid_char(int c)
+int is_url_valid_char(int c)
 {
     return (isalpha(c) ||
	    isdigit(c) ||
