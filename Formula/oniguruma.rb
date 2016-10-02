class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.1.1/onig-6.1.1.tar.gz"
  sha256 "b9cf2eefef5105820c97f94a2ccd12ed8aa274a576ccdaaed3c632a2aa0d0f04"
  revision 1

  bottle do
    cellar :any
    sha256 "8b869f01524a047aefa59d984f9d7a09bb629bf2fe1af964540d4e335ce0166a" => :sierra
    sha256 "94fc0d6205348bb2462b3786f917547068a86c8ee8d48462297e2a666d69ad7e" => :el_capitan
    sha256 "775764a099ba44167efdb9ad76e6d082c772100a3c92e060ec6dd0102ceb2e04" => :yosemite
    sha256 "3714187af50dfaa7106796167bb604a73f84a69e9daef725a4df1f2b06fec992" => :mavericks
  end

  # Fix wrong usage of UChar instead of OnigUChar in oniguruma.h
  # Patch is from develop branch of kkos/oniguruma and can be dropped in next release.
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end

__END__
diff --git a/src/oniguruma.h b/src/oniguruma.h
--- a/src/oniguruma.h
+++ b/src/oniguruma.h
@@ -364,7 +364,7 @@ int onigenc_strlen_null P_((OnigEncoding enc, const OnigUChar* p));
 ONIG_EXTERN
 int onigenc_str_bytelen_null P_((OnigEncoding enc, const OnigUChar* p));
 ONIG_EXTERN
-int onigenc_is_valid_mbc_string P_((OnigEncoding enc, const UChar* s, const UChar* end));
+int onigenc_is_valid_mbc_string P_((OnigEncoding enc, const OnigUChar* s, const OnigUChar* end));
 
 
 
@@ -742,7 +742,7 @@ void onig_free P_((OnigRegex));
 ONIG_EXTERN
 void onig_free_body P_((OnigRegex));
 ONIG_EXTERN
-int onig_scan(regex_t* reg, const UChar* str, const UChar* end, OnigRegion* region, OnigOptionType option, int (*scan_callback)(int, int, OnigRegion*, void*), void* callback_arg);
+int onig_scan(regex_t* reg, const OnigUChar* str, const OnigUChar* end, OnigRegion* region, OnigOptionType option, int (*scan_callback)(int, int, OnigRegion*, void*), void* callback_arg);
 ONIG_EXTERN
 int onig_search P_((OnigRegex, const OnigUChar* str, const OnigUChar* end, const OnigUChar* start, const OnigUChar* range, OnigRegion* region, OnigOptionType option));
 ONIG_EXTERN
