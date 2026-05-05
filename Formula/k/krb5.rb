class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.22/krb5-1.22.2.tar.gz"
  sha256 "3243ffbc8ea4d4ac22ddc7dd2a1dc54c57874c40648b60ff97009763554eaf13"
  # From Fedora: https://src.fedoraproject.org/rpms/krb5/blob/rawhide/f/krb5.spec
  license all_of: [
    "BSD-2-Clause",
    "BSD-2-Clause-first-lines",
    "BSD-3-Clause",
    "BSD-4-Clause",
    "Brian-Gladman-2-Clause",
    "CMU-Mach-nodoc",
    "FSFULLRWD",
    "HPND",
    "HPND-export2-US",
    "HPND-export-US",
    "HPND-export-US-acknowledgement",
    "HPND-export-US-modify",
    "ISC",
    "MIT",
    "MIT-CMU",
    "OLDAP-2.8",
    "OpenVision",
    any_of: ["BSD-2-Clause", "GPL-2.0-or-later"],
  ]
  revision 1
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 arm64_tahoe:   "7dfebc9f62c755f92d8ca86db895dcfad91c8b171d13faa6a079a2d7d52a2724"
    sha256 arm64_sequoia: "7764f693b98ec76df4e5152ad8a9a8a693f2f5ecb50e9456d97a5cf3ada22bc0"
    sha256 arm64_sonoma:  "83d4a48f7101cfa6bd5edabd913db5a178f504c39e4ecb5a98cd4890468da58b"
    sha256 sonoma:        "0ea66222c73109a9a3b2e03bc7c928941c83bb5be2505b8e1d5e4404a407b8e7"
    sha256 arm64_linux:   "dcb00456dfd4aa70a46648feb5fa3d003fd8d5692e408e4a51fc6aa3855ea4b1"
    sha256 x86_64_linux:  "fdd0185dd64e685eaf3a5cab557cb3bf68ae12f0c9ffde899bd62e666c36951f"
  end

  keg_only :provided_by_macos

  depends_on "openssl@4"

  uses_from_macos "bison" => :build
  uses_from_macos "libedit"

  on_linux do
    depends_on "keyutils"
  end

  # OpenSSL 4 compatibility, upstream commit:
  # https://github.com/krb5/krb5/commit/5e4e8452328804948d042235bbf58ca457795857
  patch :DATA

  def install
    cd "src" do
      system "./configure", "--disable-nls",
                            "--disable-silent-rules",
                            "--without-system-verto",
                            *std_configure_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system bin/"krb5-config", "--version"
    assert_match include.to_s, shell_output("#{bin}/krb5-config --cflags")
  end
end

__END__
diff --git a/src/plugins/preauth/pkinit/pkinit_crypto_openssl.c b/src/plugins/preauth/pkinit/pkinit_crypto_openssl.c
index d1fe18e5ab..aa969aa37c 100644
--- a/src/plugins/preauth/pkinit/pkinit_crypto_openssl.c
+++ b/src/plugins/preauth/pkinit/pkinit_crypto_openssl.c
@@ -209,13 +209,20 @@ create_identifiers_from_stack(STACK_OF(X509) *sk,
 #define EVP_MD_CTX_new EVP_MD_CTX_create
 #define EVP_MD_CTX_free EVP_MD_CTX_destroy
 #define ASN1_STRING_get0_data ASN1_STRING_data
+#define X509_STORE_CTX_set0_trusted_stack X509_STORE_CTX_trusted_stack
 
 /*
- * 1.1 adds DHX support, which uses the RFC 3279 DomainParameters encoding we
+ * 1.0.2 adds DHX support, which uses the RFC 3279 DomainParameters encoding we
  * need for PKINIT.  For 1.0 we must use the original DH type when creating
  * EVP_PKEY objects.
  */
+#ifndef EVP_PKEY_DHX
 #define EVP_PKEY_DHX EVP_PKEY_DH
+#endif
+
+/* Make X509_NAME_print_ex() accept a const name pointer by adding a cast. */
+#define X509_NAME_print_ex(a, b, c, d)          \
+    X509_NAME_print_ex(a, (X509_NAME *)b, c, d)
 
 /* 1.1 makes many handle types opaque and adds accessors.  Add compatibility
  * versions of the new accessors we use for pre-1.1. */
@@ -295,6 +302,10 @@ compat_ECDSA_SIG_set0(ECDSA_SIG *sig, BIGNUM *r, BIGNUM *s)
 #define EVP_PKEY_get_bits EVP_PKEY_bits
 #define EVP_PKEY_get_base_id EVP_PKEY_base_id
 
+/* Make X509_dup() accept a const pointer by adding a cast. */
+#define X509_dup(a) X509_dup((X509 *)a)
+#define i2d_X509_NAME(a, b) i2d_X509_NAME((X509_NAME *)a, b)
+
 /*
  * Convert *dh to an EVP_PKEY object, taking ownership of *dh and setting it to
  * NULL.  On error, return NULL and do not take ownership of or change *dh.
@@ -318,6 +329,11 @@ dh_to_pkey(DH **dh)
 }
 #endif /* OPENSSL_VERSION_NUMBER < 0x30000000L */
 
+#if OPENSSL_VERSION_NUMBER < 0x40000000L
+/* Make X509V3_EXT_d2i() accept a const pointer by adding a cast. */
+#define X509V3_EXT_d2i(a) X509V3_EXT_d2i((X509_EXTENSION *)a)
+#endif
+
 /* Encode a bignum as an ASN.1 integer in DER. */
 static int
 encode_bn_der(const BIGNUM *bn, uint8_t **der_out, int *len_out)
@@ -1134,6 +1150,13 @@ oerr_cert(krb5_context context, krb5_error_code code, X509_STORE_CTX *certctx,
     return oerr(context, code, _("%s (depth %d): %s"), msg, depth, errstr);
 }
 
+/* Convert an OpenSSL ASN.1 string value to krb5_data, without copying. */
+static inline krb5_data
+asn1string_to_data(ASN1_STRING *s)
+{
+    return make_data((char *)ASN1_STRING_get0_data(s), ASN1_STRING_length(s));
+}
+
 krb5_error_code
 pkinit_init_plg_crypto(krb5_context context,
                        pkinit_plg_crypto_context *cryptoctx)
@@ -1775,7 +1798,7 @@ cms_signeddata_create(krb5_context context,
             goto cleanup;
         X509_STORE_CTX_init(certctx, certstore, id_cryptoctx->my_cert,
                             id_cryptoctx->intermediateCAs);
-        X509_STORE_CTX_trusted_stack(certctx, id_cryptoctx->trustedCAs);
+        X509_STORE_CTX_set0_trusted_stack(certctx, id_cryptoctx->trustedCAs);
         if (!X509_verify_cert(certctx)) {
             retval = oerr_cert(context, 0, certctx,
                                _("Failed to verify own certificate"));
@@ -2002,7 +2025,7 @@ cms_signeddata_verify(krb5_context context,
         unsigned char *d;
         *is_signed = 0;
         octets = CMS_get0_content(cms);
-        if (!octets || ((*octets)->type != V_ASN1_OCTET_STRING)) {
+        if (!octets || (ASN1_STRING_type(*octets) != V_ASN1_OCTET_STRING)) {
             retval = KRB5KDC_ERR_PREAUTH_FAILED;
             krb5_set_error_message(context, retval,
                                    _("Invalid pkinit packet: octet string "
@@ -2058,7 +2081,8 @@ cms_signeddata_verify(krb5_context context,
         /* We cannot use CMS_dataInit because there may be no digest */
         octets = CMS_get0_content(cms);
         if (octets)
-            out = BIO_new_mem_buf((*octets)->data, (*octets)->length);
+            out = BIO_new_mem_buf(ASN1_STRING_get0_data(*octets),
+                                  ASN1_STRING_length(*octets));
         if (out == NULL)
             goto cleanup;
     } else {
@@ -2118,7 +2142,7 @@ cms_signeddata_verify(krb5_context context,
 
         /* add trusted CAs certificates for cert verification */
         if (idctx->trustedCAs != NULL)
-            X509_STORE_CTX_trusted_stack(cert_ctx, idctx->trustedCAs);
+            X509_STORE_CTX_set0_trusted_stack(cert_ctx, idctx->trustedCAs);
         else {
             pkiDebug("unable to find any trusted CAs\n");
             goto cleanup;
@@ -2156,7 +2180,7 @@ cms_signeddata_verify(krb5_context context,
         i = X509_verify_cert(cert_ctx);
         if (i <= 0) {
             int j = X509_STORE_CTX_get_error(cert_ctx);
-            X509 *cert;
+            const X509 *cert;
 
             cert = X509_STORE_CTX_get_current_cert(cert_ctx);
             reqctx->received_cert = X509_dup(cert);
@@ -2316,7 +2340,7 @@ crypto_retrieve_X509_sans(krb5_context context,
     krb5_principal *princs = NULL;
     char **upns = NULL;
     unsigned char **dnss = NULL;
-    X509_EXTENSION *ext = NULL;
+    const X509_EXTENSION *ext = NULL;
     GENERAL_NAMES *ialt = NULL;
     GENERAL_NAME *gen = NULL;
 
@@ -2379,8 +2403,7 @@ crypto_retrieve_X509_sans(krb5_context context,
         gen = sk_GENERAL_NAME_value(ialt, i);
         switch (gen->type) {
         case GEN_OTHERNAME:
-            name.length = gen->d.otherName->value->value.sequence->length;
-            name.data = (char *)gen->d.otherName->value->value.sequence->data;
+            name = asn1string_to_data(gen->d.otherName->value->value.sequence);
             if (princs != NULL &&
                 OBJ_cmp(plgctx->id_pkinit_san,
                         gen->d.otherName->type_id) == 0) {
@@ -2414,12 +2437,13 @@ crypto_retrieve_X509_sans(krb5_context context,
         case GEN_DNS:
             if (dnss != NULL) {
                 /* Prevent abuse of embedded null characters. */
-                if (memchr(gen->d.dNSName->data, '\0', gen->d.dNSName->length))
+                if (memchr(ASN1_STRING_get0_data(gen->d.dNSName), '\0',
+                           ASN1_STRING_length(gen->d.dNSName)))
                     break;
                 pkiDebug("%s: found dns name = %s\n", __FUNCTION__,
-                         gen->d.dNSName->data);
+                         ASN1_STRING_get0_data(gen->d.dNSName));
                 dnss[d] = (unsigned char *)
-                    strdup((char *)gen->d.dNSName->data);
+                    strdup((char *)ASN1_STRING_get0_data(gen->d.dNSName));
                 if (dnss[d] == NULL) {
                     pkiDebug("%s: failed to duplicate dns name\n",
                              __FUNCTION__);
@@ -3094,8 +3118,10 @@ int
 pkinit_openssl_init(void)
 {
     /* Initialize OpenSSL. */
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
     ERR_load_crypto_strings();
     OpenSSL_add_all_algorithms();
+#endif
     return 0;
 }
 
@@ -4766,7 +4792,7 @@ crypto_retrieve_X509_key_usage(krb5_context context,
 }
 
 static krb5_error_code
-rfc2253_name(X509_NAME *name, char **str_out)
+rfc2253_name(const X509_NAME *name, char **str_out)
 {
     BIO *b = NULL;
     char *str;
@@ -5227,7 +5253,7 @@ create_identifiers_from_stack(STACK_OF(X509) *sk,
     int i = 0, sk_size = sk_X509_num(sk);
     krb5_external_principal_identifier **krb5_cas = NULL;
     X509 *x = NULL;
-    X509_NAME *xn = NULL;
+    const X509_NAME *xn = NULL;
     unsigned char *p = NULL;
     int len = 0;
     PKCS7_ISSUER_AND_SERIAL *is = NULL;
diff --git a/src/plugins/tls/k5tls/openssl.c b/src/plugins/tls/k5tls/openssl.c
index 42d72dc9ec..7763327b7a 100644
--- a/src/plugins/tls/k5tls/openssl.c
+++ b/src/plugins/tls/k5tls/openssl.c
@@ -38,6 +38,24 @@
 #include <openssl/x509v3.h>
 #include <dirent.h>
 
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
+/* Make X509_get_subject_name() accept a const pointer by adding a cast. */
+#define X509_get_subject_name(a) X509_get_subject_name((X509 *)a)
+
+/* OpenSSL 1.0 did not have TLS_client_method(); use the best alternative. */
+#define TLS_client_method() SSLv23_client_method()
+#endif
+
+#if OPENSSL_VERSION_NUMBER < 0x40000000L
+/*
+ * OpenSSL 4.0 constifies the result of X509_STORE_CTX_get_current_cert() and
+ * the input of X509_check_host() and X509_check_ip_asc().  For prior versions,
+ * make the latter two functions accept const pointers via a cast.
+ */
+#define X509_check_host(a, b, c, d, e) X509_check_host((X509 *)a, b, c, d, e)
+#define X509_check_ip_asc(a, b, c) X509_check_ip_asc((X509 *)a, b, c)
+#endif
+
 struct k5_tls_handle_st {
     SSL *ssl;
     char *servername;
@@ -51,9 +69,11 @@ MAKE_INIT_FUNCTION(init_openssl);
 int
 init_openssl(void)
 {
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
     SSL_library_init();
     SSL_load_error_strings();
     OpenSSL_add_all_algorithms();
+#endif
     ex_context_id = SSL_get_ex_new_index(0, NULL, NULL, NULL, NULL);
     ex_handle_id = SSL_get_ex_new_index(0, NULL, NULL, NULL, NULL);
     return 0;
@@ -72,7 +92,7 @@ flush_errors(krb5_context context)
 }
 
 static krb5_boolean
-check_cert_name_or_ip(X509 *x, const char *expected_name)
+check_cert_name_or_ip(const X509 *x, const char *expected_name)
 {
     struct in_addr in;
     struct in6_addr in6;
@@ -89,7 +109,7 @@ check_cert_name_or_ip(X509 *x, const char *expected_name)
 static int
 verify_callback(int preverify_ok, X509_STORE_CTX *store_ctx)
 {
-    X509 *x;
+    const X509 *x;
     SSL *ssl;
     BIO *bio;
     krb5_context context;
@@ -246,7 +266,7 @@ setup(krb5_context context, SOCKET fd, const char *servername,
         return KRB5_PLUGIN_OP_NOTSUPP;
 
     /* Do general SSL library setup. */
-    ctx = SSL_CTX_new(SSLv23_client_method());
+    ctx = SSL_CTX_new(TLS_client_method());
     if (ctx == NULL)
         goto error;
 
