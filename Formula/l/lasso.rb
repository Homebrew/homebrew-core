class Lasso < Formula
  include Language::Python::Virtualenv

  desc "Library for Liberty Alliance and SAML protocols"
  homepage "https://lasso.entrouvert.org/"
  url "https://dev.entrouvert.org/releases/lasso/lasso-2.8.2.tar.gz"
  sha256 "6a1831bfdbf8f424c7508aba47b045d51341ec0fde9122f38b0b86b096ef533e"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?lasso[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bae175f8483fcb721716c04489109384cf80f7b1b3e2dfddfe2bbb785e0cbddf"
    sha256 cellar: :any,                 arm64_ventura:  "1d90d46ff6490946d1f8e156038fb83fe63c59f7bebab3b712ee6eeaf73175c9"
    sha256 cellar: :any,                 arm64_monterey: "9b7b4aaf4ebb484bc9965c44ec60b5688bf07160fd21009b3698c9906339ceca"
    sha256 cellar: :any,                 sonoma:         "1ae094adf28b557f503e6902eba7782fc3f06851f99af55bb719cd1ef5421acc"
    sha256 cellar: :any,                 ventura:        "c70b29501fec372898d179cc2b90a8778135b1b90679cedbc9d04967c23be6ca"
    sha256 cellar: :any,                 monterey:       "c502d05c3014a4bc43418345944c10ad4f5aa7e65743a83b374b51f8f44d2eff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9adf24a05cbf953ad5f3d3bca3f388eadb08480aaf9f100663504c2ea83ff025"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  resource "six" do
    on_linux do
      url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
      sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
    end
  end

  # patch from upstream issue: https://dev.entrouvert.org/issues/85339
  # Remove when https://git.entrouvert.org/entrouvert/lasso/pulls/10/ is merged
  #
  # Backport https://git.entrouvert.org/entrouvert/lasso/commit/cbe2c45455d93ed793dc4be59e3d2d26f1bd1111
  # Remove on the next release (starting from "diff --git a/lasso/lasso.c b/lasso/lasso.c")
  patch :DATA

  def install
    ENV["PYTHON"] = if OS.linux?
      venv = virtualenv_create(buildpath/"venv", "python3")
      venv.pip_install resources
      venv.root/"bin/python"
    else
      DevelopmentTools.locate("python3") || DevelopmentTools.locate("python")
    end

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
    (testpath/"test.c").write <<~EOS
      #include <lasso/lasso.h>

      int main() {
        return lasso_init();
      }
    EOS
    system ENV.cc, "test.c",
                   "-I#{Formula["glib"].include}/glib-2.0",
                   "-I#{Formula["glib"].lib}/glib-2.0/include",
                   "-I#{Formula["libxml2"].include}/libxml2",
                   "-I#{Formula["libxmlsec1"].include}/xmlsec1",
                   "-L#{lib}", "-llasso", "-o", "test"
    system "./test"
  end
end
__END__
diff --git a/lasso/xml/tools.c b/lasso/xml/tools.c
index 4d5fa78a..0478f3f4 100644
--- a/lasso/xml/tools.c
+++ b/lasso/xml/tools.c
@@ -64,6 +64,7 @@
 #include <glib.h>
 #include "xml.h"
 #include "xml_enc.h"
+#include "id-ff/server.h"
 #include "saml-2.0/saml2_assertion.h"
 #include <unistd.h>
 #include "../debug.h"
@@ -309,7 +310,7 @@ xmlSecKeyPtr lasso_get_public_key_from_pem_file(const char *file) {
 			pub_key = lasso_get_public_key_from_pem_cert_file(file);
 			break;
 		case LASSO_PEM_FILE_TYPE_PUB_KEY:
-			pub_key = xmlSecCryptoAppKeyLoad(file,
+			pub_key = xmlSecCryptoAppKeyLoadEx(file, xmlSecKeyDataTypePublic | xmlSecKeyDataTypePrivate,
 					xmlSecKeyDataFormatPem, NULL, NULL, NULL);
 			break;
 		case LASSO_PEM_FILE_TYPE_PRIVATE_KEY:
@@ -378,7 +379,7 @@ lasso_get_public_key_from_pem_cert_file(const char *pem_cert_file)
 static xmlSecKeyPtr
 lasso_get_public_key_from_private_key_file(const char *private_key_file)
 {
-	return xmlSecCryptoAppKeyLoad(private_key_file,
+	return xmlSecCryptoAppKeyLoadEx(private_key_file, xmlSecKeyDataTypePrivate | xmlSecKeyDataTypePublic,
 			xmlSecKeyDataFormatPem, NULL, NULL, NULL);
 }
 
@@ -2704,7 +2705,7 @@ cleanup:
 xmlSecKeyPtr
 lasso_xmlsec_load_key_info(xmlNode *key_descriptor)
 {
-	xmlSecKeyPtr key, result = NULL;
+	xmlSecKeyPtr key = NULL, result = NULL;
 	xmlNodePtr key_info = NULL;
 	xmlSecKeyInfoCtx ctx = {0};
 	xmlSecKeysMngr *keys_mngr = NULL;
@@ -2738,6 +2739,17 @@ lasso_xmlsec_load_key_info(xmlNode *key_descriptor)
 	ctx.keyReq.keyUsage = xmlSecKeyDataUsageAny;
 	ctx.certsVerificationDepth = 0;
 
+	if((xmlSecPtrListAdd(&ctx.enabledKeyData, BAD_CAST xmlSecKeyDataX509Id) < 0) ||
+		(xmlSecPtrListAdd(&ctx.enabledKeyData, BAD_CAST xmlSecKeyDataValueId) < 0) ||
+		(xmlSecPtrListAdd(&ctx.enabledKeyData, BAD_CAST xmlSecKeyDataRsaId) < 0) ||
+		(xmlSecPtrListAdd(&ctx.enabledKeyData, BAD_CAST xmlSecKeyDataDsaId) < 0) ||
+		(xmlSecPtrListAdd(&ctx.enabledKeyData, BAD_CAST xmlSecKeyDataHmacId) < 0)) {
+		message(G_LOG_LEVEL_CRITICAL, "Could not enable needed KeyData");
+		goto next;
+	}
+
+
+
 	key = xmlSecKeyCreate();
 	if (lasso_flag_pem_public_key) {
 		xmlSecErrorsDefaultCallbackEnableOutput(FALSE);
diff --git a/lasso/xml/xml.c b/lasso/xml/xml.c
index 0d5c6e31..09cc3037 100644
--- a/lasso/xml/xml.c
+++ b/lasso/xml/xml.c
@@ -620,6 +620,10 @@ lasso_node_encrypt(LassoNode *lasso_node, xmlSecKey *encryption_public_key,
 		goto cleanup;
 	}
 
+#if (XMLSEC_MAJOR > 1) || (XMLSEC_MAJOR == 1 && XMLSEC_MINOR > 3) || (XMLSEC_MAJOR == 1 && XMLSEC_MINOR == 3 && XMLSEC_SUBMINOR >= 0)
+	enc_ctx->keyInfoWriteCtx.flags |= XMLSEC_KEYINFO_FLAGS_LAX_KEY_SEARCH;
+#endif
+
 	/* generate a symetric key */
 	switch (encryption_sym_key_type) {
 		case LASSO_ENCRYPTION_SYM_KEY_TYPE_AES_256:
diff --git a/lasso/lasso.c b/lasso/lasso.c
index 42b7d6bb..bc75f5e6 100644
--- a/lasso/lasso.c
+++ b/lasso/lasso.c
@@ -138,7 +138,13 @@ DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
 #include "types.c"
 
 static void
-lasso_xml_structured_error_func(G_GNUC_UNUSED void *user_data, xmlErrorPtr error)
+lasso_xml_structured_error_func(G_GNUC_UNUSED void *user_data,
+#if LIBXML_VERSION >= 21200
+                                        const xmlError *error
+#else
+                                        xmlErrorPtr error
+#endif
+				)
 {
 	g_log("libxml2", G_LOG_LEVEL_DEBUG, "libxml2: %s", error->message);
 }
diff --git a/lasso/xml/tools.c b/lasso/xml/tools.c
index bbc87d9f..4d5fa78a 100644
--- a/lasso/xml/tools.c
+++ b/lasso/xml/tools.c
@@ -1450,7 +1450,14 @@ lasso_concat_url_query(const char *url, const char *query)
 	}
 }
 
-static void structuredErrorFunc (void *userData, xmlErrorPtr error) {
+static void structuredErrorFunc (void *userData,
+#if LIBXML_VERSION >= 21200
+                                        const xmlError *error
+#else
+                                        xmlErrorPtr error
+#endif
+				 )
+{
 		*(int*)userData = error->code;
 }
 
