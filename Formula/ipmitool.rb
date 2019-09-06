class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "https://github.com/ipmitool/ipmitool"
  url "https://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.18/ipmitool-1.8.18.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/i/ipmitool/ipmitool_1.8.18.orig.tar.bz2"
  sha256 "0c1ba3b1555edefb7c32ae8cd6a3e04322056bc087918f07189eeedfc8b81e01"
  revision 3

  bottle do
    cellar :any
    sha256 "80039ed77975cdfc9b50ce83750b28be15dca7506c482cc43e60791359ac4240" => :mojave
    sha256 "ffea0646f0d1ce2d773f1566fe813e36c3ab8d409ad26580c87709d696401fd4" => :high_sierra
    sha256 "c7e13ccde0f639c52aa915a71f9779ec0b514ed1260c5c9078754498f80c9ec3" => :sierra
    sha256 "d6ce46b2b93ac040cb3ac235bd68ecab496b8dbebee22fb4fb69ad52aa75e9c9" => :el_capitan
    sha256 "5e9ad832c757416534a30df441ba41f83a4634bb80c224d4e42e7395b58cb9a6" => :yosemite
  end

  depends_on "openssl@1.1"

  # https://sourceforge.net/p/ipmitool/bugs/433/#89ea and
  # https://sourceforge.net/p/ipmitool/bugs/436/ (prematurely closed):
  # Fix segfault when prompting for password
  # Re-reported 12 July 2017 https://sourceforge.net/p/ipmitool/mailman/message/35942072/
  patch do
    url "https://gist.githubusercontent.com/adaugherity/87f1466b3c93d5aed205a636169d1c58/raw/29880afac214c1821e34479dad50dca58a0951ef/ipmitool-getpass-segfault.patch"
    sha256 "fc1cff11aa4af974a3be191857baeaf5753d853024923b55c720eac56f424038"
  end

  # Patch for compatibility with OpenSSL 1.1.1
  # https://reviews.freebsd.org/D17527
  patch :p0, :DATA

  def install
    # Fix ipmi_cfgp.c:33:10: fatal error: 'malloc.h' file not found
    # Upstream issue from 8 Nov 2016 https://sourceforge.net/p/ipmitool/bugs/474/
    inreplace "lib/ipmi_cfgp.c", "#include <malloc.h>", ""

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --disable-intf-usb
    ]
    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  test do
    # Test version print out
    system bin/"ipmitool", "-V"
  end
end
__END__
--- src/plugins/lanplus/lanplus_crypt_impl.c.orig	2016-05-28 08:20:20 UTC
+++ src/plugins/lanplus/lanplus_crypt_impl.c
@@ -164,11 +164,7 @@ lanplus_encrypt_aes_cbc_128(const uint8_t * iv,
							uint8_t       * output,
							uint32_t        * bytes_written)
 {
-	EVP_CIPHER_CTX ctx;
-	EVP_CIPHER_CTX_init(&ctx);
-	EVP_EncryptInit_ex(&ctx, EVP_aes_128_cbc(), NULL, key, iv);
-	EVP_CIPHER_CTX_set_padding(&ctx, 0);
-
+	EVP_CIPHER_CTX *ctx = NULL;

	*bytes_written = 0;

@@ -182,6 +178,13 @@ lanplus_encrypt_aes_cbc_128(const uint8_t * iv,
		printbuf(input, input_length, "encrypting this data");
	}

+	ctx = EVP_CIPHER_CTX_new();
+	if (ctx == NULL) {
+		lprintf(LOG_DEBUG, "ERROR: EVP_CIPHER_CTX_new() failed");
+		return;
+	}
+	EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), NULL, key, iv);
+	EVP_CIPHER_CTX_set_padding(ctx, 0);

	/*
	 * The default implementation adds a whole block of padding if the input
@@ -191,28 +194,28 @@ lanplus_encrypt_aes_cbc_128(const uint8_t * iv,
	assert((input_length % IPMI_CRYPT_AES_CBC_128_BLOCK_SIZE) == 0);


-	if(!EVP_EncryptUpdate(&ctx, output, (int *)bytes_written, input, input_length))
+	if(!EVP_EncryptUpdate(ctx, output, (int *)bytes_written, input, input_length))
	{
		/* Error */
		*bytes_written = 0;
-		return;
	}
	else
	{
		uint32_t tmplen;

-		if(!EVP_EncryptFinal_ex(&ctx, output + *bytes_written, (int *)&tmplen))
+		if(!EVP_EncryptFinal_ex(ctx, output + *bytes_written, (int *)&tmplen))
		{
+			/* Error */
			*bytes_written = 0;
-			return; /* Error */
		}
		else
		{
			/* Success */
			*bytes_written += tmplen;
-			EVP_CIPHER_CTX_cleanup(&ctx);
		}
	}
+	/* performs cleanup and free */
+	EVP_CIPHER_CTX_free(ctx);
 }


@@ -239,12 +242,8 @@ lanplus_decrypt_aes_cbc_128(const uint8_t * iv,
							uint8_t       * output,
							uint32_t        * bytes_written)
 {
-	EVP_CIPHER_CTX ctx;
-	EVP_CIPHER_CTX_init(&ctx);
-	EVP_DecryptInit_ex(&ctx, EVP_aes_128_cbc(), NULL, key, iv);
-	EVP_CIPHER_CTX_set_padding(&ctx, 0);
+	EVP_CIPHER_CTX *ctx;

-
	if (verbose >= 5)
	{
		printbuf(iv,  16, "decrypting with this IV");
@@ -252,12 +251,19 @@ lanplus_decrypt_aes_cbc_128(const uint8_t * iv,
		printbuf(input, input_length, "decrypting this data");
	}

-
	*bytes_written = 0;

	if (input_length == 0)
		return;

+	ctx = EVP_CIPHER_CTX_new();
+	if (ctx == NULL) {
+		*bytes_written = 0;
+		return;
+	}
+	EVP_DecryptInit_ex(ctx, EVP_aes_128_cbc(), NULL, key, iv);
+	EVP_CIPHER_CTX_set_padding(ctx, 0);
+
	/*
	 * The default implementation adds a whole block of padding if the input
	 * data is perfectly aligned.  We would like to keep that from happening.
@@ -266,31 +272,29 @@ lanplus_decrypt_aes_cbc_128(const uint8_t * iv,
	assert((input_length % IPMI_CRYPT_AES_CBC_128_BLOCK_SIZE) == 0);


-	if (!EVP_DecryptUpdate(&ctx, output, (int *)bytes_written, input, input_length))
+	if (!EVP_DecryptUpdate(ctx, output, (int *)bytes_written, input, input_length))
	{
		/* Error */
		lprintf(LOG_DEBUG, "ERROR: decrypt update failed");
		*bytes_written = 0;
-		return;
	}
	else
	{
		uint32_t tmplen;

-		if (!EVP_DecryptFinal_ex(&ctx, output + *bytes_written, (int *)&tmplen))
+		if (!EVP_DecryptFinal_ex(ctx, output + *bytes_written, (int *)&tmplen))
		{
+			/* Error */
			char buffer[1000];
			ERR_error_string(ERR_get_error(), buffer);
			lprintf(LOG_DEBUG, "the ERR error %s", buffer);
			lprintf(LOG_DEBUG, "ERROR: decrypt final failed");
			*bytes_written = 0;
-			return; /* Error */
		}
		else
		{
			/* Success */
			*bytes_written += tmplen;
-			EVP_CIPHER_CTX_cleanup(&ctx);
		}
	}

@@ -299,4 +303,6 @@ lanplus_decrypt_aes_cbc_128(const uint8_t * iv,
		lprintf(LOG_DEBUG, "Decrypted %d encrypted bytes", input_length);
		printbuf(output, *bytes_written, "Decrypted this data");
	}
+	/* performs cleanup and free */
+	EVP_CIPHER_CTX_free(ctx);
 }
