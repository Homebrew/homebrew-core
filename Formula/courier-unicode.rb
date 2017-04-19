class CourierUnicode < Formula
  desc "Implements several algorithms related to the Unicode Standard"
  homepage "http://www.courier-mta.org/unicode/"
  url "https://downloads.sourceforge.net/project/courier/courier-unicode/1.4/courier-unicode-1.4.tar.bz2"
  sha256 "2174f4cdd2cd3fe554d4cbbd9557abac0e54c0226084f368bcb2e66b0e78cf96"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    # https://sourceforge.net/p/courier/mailman/message/34719502/
    inreplace "courier-unicode.h", "extern const char *unicode_locale_chset_l(locale_t l);", ""
    system "make"
    system "make", "install"
  end

  # https://sourceforge.net/p/courier/mailman/message/34719502/
  patch :p0, :DATA

  test do
    system "false"
  end
end

__END__
--- unicode.c
+++ unicode.c
@@ -37,13 +37,6 @@
 	return fix_charset(c);
 }
 
-#if HAVE_LANGINFO_L
-const char *unicode_locale_chset_l(locale_t l)
-{
-	return fix_charset(nl_langinfo_l(CODESET, l));
-}
-#endif
-
 static const char *fix_charset(const char *c)
 {
 	if (!c)
