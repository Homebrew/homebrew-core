class Dmg2img < Formula
  desc "Utilities for converting macOS DMG images"
  homepage "http://vu1tur.eu.org/tools/"
  url "http://vu1tur.eu.org/tools/dmg2img-1.6.7.tar.gz"
  sha256 "02aea6d05c5b810074913b954296ddffaa43497ed720ac0a671da4791ec4d018"
  revision 1

  bottle do
    cellar :any
    sha256 "fb90741dc01f5c7b115c9d5bf142e36a90d7cf0995ecb4a5183150ec6d6161ac" => :mojave
    sha256 "367ab961e50114debc983e5665443ee8fa5a85a2b4fab024753f38df48fb26f1" => :high_sierra
    sha256 "8616423fd5b0109c66a000932b2aa5bf4f3979c5a065617e8ef7dd4ae0ee820b" => :sierra
  end

  depends_on "openssl@1.1"

  # Patch for OpenSSL 1.1 compatibility
  patch :p0, :DATA

  def install
    system "make"
    bin.install "dmg2img"
    bin.install "vfdecrypt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dmg2img")
    output = shell_output("#{bin}/vfdecrypt 2>&1", 1)
    assert_match "No Passphrase given.", output
  end
end
__END__
--- vfdecrypt.c.old	2019-09-11 14:46:50.000000000 +0200
+++ vfdecrypt.c	2019-09-11 14:46:53.000000000 +0200
@@ -183,7 +183,7 @@ void adjust_v2_header_byteorder(cencrypt
   pwhdr->encrypted_keyblob_size = htonl(pwhdr->encrypted_keyblob_size);
 }

-HMAC_CTX hmacsha1_ctx;
+HMAC_CTX *hmacsha1_ctx;
 AES_KEY aes_decrypt_key;
 int CHUNK_SIZE=4096;  // default

@@ -196,9 +196,9 @@ void compute_iv(uint32_t chunk_no, uint8
   unsigned int mdLen;

   chunk_no = OSSwapHostToBigInt32(chunk_no);
-  HMAC_Init_ex(&hmacsha1_ctx, NULL, 0, NULL, NULL);
-  HMAC_Update(&hmacsha1_ctx, (void *) &chunk_no, sizeof(uint32_t));
-  HMAC_Final(&hmacsha1_ctx, mdResult, &mdLen);
+  HMAC_Init_ex(hmacsha1_ctx, NULL, 0, NULL, NULL);
+  HMAC_Update(hmacsha1_ctx, (void *) &chunk_no, sizeof(uint32_t));
+  HMAC_Final(hmacsha1_ctx, mdResult, &mdLen);
   memcpy(iv, mdResult, CIPHER_BLOCKSIZE);
 }

@@ -212,47 +212,45 @@ void decrypt_chunk(uint8_t *ctext, uint8
 /* DES3-EDE unwrap operation loosely based on to RFC 2630, section 12.6
  *    wrapped_key has to be 40 bytes in length.  */
 int apple_des3_ede_unwrap_key(uint8_t *wrapped_key, int wrapped_key_len, uint8_t *decryptKey, uint8_t *unwrapped_key) {
-  EVP_CIPHER_CTX ctx;
+  EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
   uint8_t *TEMP1, *TEMP2, *CEKICV;
   uint8_t IV[8] = { 0x4a, 0xdd, 0xa2, 0x2c, 0x79, 0xe8, 0x21, 0x05 };
   int outlen, tmplen, i;

-  EVP_CIPHER_CTX_init(&ctx);
   /* result of the decryption operation shouldn't be bigger than ciphertext */
   TEMP1 = malloc(wrapped_key_len);
   TEMP2 = malloc(wrapped_key_len);
   CEKICV = malloc(wrapped_key_len);
   /* uses PKCS#7 padding for symmetric key operations by default */
-  EVP_DecryptInit_ex(&ctx, EVP_des_ede3_cbc(), NULL, decryptKey, IV);
+  EVP_DecryptInit_ex(ctx, EVP_des_ede3_cbc(), NULL, decryptKey, IV);

-  if(!EVP_DecryptUpdate(&ctx, TEMP1, &outlen, wrapped_key, wrapped_key_len)) {
+  if(!EVP_DecryptUpdate(ctx, TEMP1, &outlen, wrapped_key, wrapped_key_len)) {
     fprintf(stderr, "internal error (1) during key unwrap operation!\n");
     return(-1);
   }
-  if(!EVP_DecryptFinal_ex(&ctx, TEMP1 + outlen, &tmplen)) {
+  if(!EVP_DecryptFinal_ex(ctx, TEMP1 + outlen, &tmplen)) {
     fprintf(stderr, "internal error (2) during key unwrap operation!\n");
     return(-1);
   }
   outlen += tmplen;
-  EVP_CIPHER_CTX_cleanup(&ctx);

   /* reverse order of TEMP3 */
   for(i = 0; i < outlen; i++) TEMP2[i] = TEMP1[outlen - i - 1];

-  EVP_CIPHER_CTX_init(&ctx);
+  EVP_CIPHER_CTX_reset(ctx);
   /* uses PKCS#7 padding for symmetric key operations by default */
-  EVP_DecryptInit_ex(&ctx, EVP_des_ede3_cbc(), NULL, decryptKey, TEMP2);
-  if(!EVP_DecryptUpdate(&ctx, CEKICV, &outlen, TEMP2+8, outlen-8)) {
+  EVP_DecryptInit_ex(ctx, EVP_des_ede3_cbc(), NULL, decryptKey, TEMP2);
+  if(!EVP_DecryptUpdate(ctx, CEKICV, &outlen, TEMP2+8, outlen-8)) {
     fprintf(stderr, "internal error (3) during key unwrap operation!\n");
     return(-1);
   }
-  if(!EVP_DecryptFinal_ex(&ctx, CEKICV + outlen, &tmplen)) {
+  if(!EVP_DecryptFinal_ex(ctx, CEKICV + outlen, &tmplen)) {
     fprintf(stderr, "internal error (4) during key unwrap operation!\n");
     return(-1);
   }

   outlen += tmplen;
-  EVP_CIPHER_CTX_cleanup(&ctx);
+  EVP_CIPHER_CTX_free(ctx);

   memcpy(unwrapped_key, CEKICV+4, outlen-4);
   free(TEMP1);
@@ -279,7 +277,7 @@ int unwrap_v1_header(char *passphrase, c
 int unwrap_v2_header(char *passphrase, cencrypted_v2_pwheader *header, uint8_t *aes_key, uint8_t *hmacsha1_key) {
   /* derived key is a 3DES-EDE key */
   uint8_t derived_key[192/8];
-  EVP_CIPHER_CTX ctx;
+  EVP_CIPHER_CTX *ctx;
   uint8_t *TEMP1;
   int outlen, tmplen;

@@ -288,22 +286,22 @@ int unwrap_v2_header(char *passphrase, c

   print_hex(derived_key, 192/8);

-  EVP_CIPHER_CTX_init(&ctx);
+  ctx = EVP_CIPHER_CTX_new();
   /* result of the decryption operation shouldn't be bigger than ciphertext */
   TEMP1 = malloc(header->encrypted_keyblob_size);
   /* uses PKCS#7 padding for symmetric key operations by default */
-  EVP_DecryptInit_ex(&ctx, EVP_des_ede3_cbc(), NULL, derived_key, header->blob_enc_iv);
+  EVP_DecryptInit_ex(ctx, EVP_des_ede3_cbc(), NULL, derived_key, header->blob_enc_iv);

-  if(!EVP_DecryptUpdate(&ctx, TEMP1, &outlen, header->encrypted_keyblob, header->encrypted_keyblob_size)) {
+  if(!EVP_DecryptUpdate(ctx, TEMP1, &outlen, header->encrypted_keyblob, header->encrypted_keyblob_size)) {
     fprintf(stderr, "internal error (1) during key unwrap operation!\n");
     return(-1);
   }
-  if(!EVP_DecryptFinal_ex(&ctx, TEMP1 + outlen, &tmplen)) {
+  if(!EVP_DecryptFinal_ex(ctx, TEMP1 + outlen, &tmplen)) {
     fprintf(stderr, "internal error (2) during key unwrap operation!\n");
     return(-1);
   }
   outlen += tmplen;
-  EVP_CIPHER_CTX_cleanup(&ctx);
+  EVP_CIPHER_CTX_free(ctx);
   memcpy(aes_key, TEMP1, 16);
   memcpy(hmacsha1_key, TEMP1, 20);

@@ -446,8 +444,8 @@ int main(int argc, char *argv[]) {
     CHUNK_SIZE = v2header.blocksize;
   }

-  HMAC_CTX_init(&hmacsha1_ctx);
-  HMAC_Init_ex(&hmacsha1_ctx, hmacsha1_key, sizeof(hmacsha1_key), EVP_sha1(), NULL);
+  hmacsha1_ctx = HMAC_CTX_new();
+  HMAC_Init_ex(hmacsha1_ctx, hmacsha1_key, sizeof(hmacsha1_key), EVP_sha1(), NULL);
   AES_set_decrypt_key(aes_key, CIPHER_KEY_LENGTH * 8, &aes_decrypt_key);

   if (verbose >= 1) {
