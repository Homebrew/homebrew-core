class Msdl < Formula
  desc "Downloader for various streaming protocols"
  homepage "https://msdl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/msdl/msdl/msdl-1.2.7-r2/msdl-1.2.7-r2.tar.gz"
  version "1.2.7-r2"
  sha256 "0297e87bafcab885491b44f71476f5d5bfc648557e7d4ef36961d44dd430a3a1"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/msdl[._-]v?(\d+(?:\.\d+)+(?:-r\d+)?)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1624aa62efe3286085580bfc9482ff6e163e9dc3be33a0b485ebca7a0a91dd3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9ab0083cb6623f31de8bd191354b00f627c0b7826646eae177337a2adc823dae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "081c8df653ff58f6f08ae5758481e4fa94f4786f2465def703e93009f6ae91bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a22fd7fd9ae5684a10a7646d42a1397b700a31db017be4a40e95ad37ce2d02b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bbb7be167030b97337113482fe1007cf0f48a9fbc343f590b19c9964827e71e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5afd80d5dc62ee3c7a65fe5214d2fe51d89f8eda7ae9bb358bab102f5dd65e6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1e540f838d6ed599d61c07efebd39d83021dfc9cc1eff67bc401a0fc924204b"
    sha256 cellar: :any_skip_relocation, ventura:        "f2dceb8e2a874043888797e3ad8693aa41babf5c080afe531169ee2fff4e180a"
    sha256 cellar: :any_skip_relocation, monterey:       "f41e17e53c1b292088d9f3160bbba5241b5e467e372c4ae860277038a4daf3e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8703e042137fa27ddbda861bc9e04cea40edb5d3d3c6b4a90f5e850ee01326a"
    sha256 cellar: :any_skip_relocation, catalina:       "71fb71cf2c24085221ee1d24c57fbe07f1b6cc437d84385d22231a4723771207"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e60c658707ae055375b4402d09b83e121bd25f28ed5167cdd810d50ef02342c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5664cc49f99975d426fab1e8518356d8842512ab773aa4c2a3abe0fb957d1881"
  end

  # Fixes linker error under clang; apparently reported upstream:
  # https://github.com/Homebrew/homebrew/pull/13907
  patch :DATA

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `display_flags'; asf.o:(.bss+0x0): first defined here
    # multiple definition of `colors_available'; asf.o:(.bss+0x4): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"msdl", "http://example.org/index.html"
    assert_path_exists "index.html"
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
