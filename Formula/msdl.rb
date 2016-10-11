class Msdl < Formula
  desc "Downloader for various streaming protocols"
  homepage "http://msdl.sourceforge.net"
  url "https://downloads.sourceforge.net/msdl/msdl-1.2.7-r2.tar.gz"
  version "1.2.7-r2"
  sha256 "0297e87bafcab885491b44f71476f5d5bfc648557e7d4ef36961d44dd430a3a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "69b04b6f10ea552b6c862110434cc63dfa6bfccdc8034edd70fed5db0f79e68b" => :sierra
    sha256 "34ba320e82d1ce97fb0a106abd2c5ec848ba16857730ba51cadd0a030bee62ab" => :el_capitan
    sha256 "5b8ac26e3adbb19386398a5500a8d5631d426b2e0e951433134b5383b80bb568" => :yosemite
    sha256 "a28059bba6256df7233eacbfdadd9eeec2c3c6ec22038cb06ca49745b347a828" => :mavericks
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
