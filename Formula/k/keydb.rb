class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/Snapchat/KeyDB/archive/refs/tags/v6.3.4.tar.gz"
  sha256 "229190b251f921e05aff7b0d2f04b5676c198131e2abbec1e2cfb2e61215e2f3"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dbd7a7d4d5dd931fb2fa335d9ffe8ac973599524b3035138cfeed494ba8f0737"
    sha256 cellar: :any, arm64_tahoe:       "76057a065995260cf2e4d9e6fd9b6d7e133920f0d996e700028b718c0cddf02d"
    sha256 cellar: :any, arm64_sequoia:     "5de0dcfd335e9541513acc7e34ebff337877cdc7b6bff9c31728550d227f7028"
    sha256 cellar: :any, arm64_linux:       "92811aa9754106ca67d3d9788523205d858b5e31b99e48b6d4a3a1e08b06cc16"
    sha256 cellar: :any, x86_64_linux:      "ea3a83d006ebfbf56149cfcb5b78ec59b4cec3e4a1c9c239ecb1490992ccc52c"
  end

  # Last release on 2023-10-30 and last activity on 2024-04-04.
  # Also see: https://github.com/Snapchat/KeyDB/issues/895
  deprecate! date: "2026-10-04", because: :unmaintained
  disable! date: "2027-04-04", because: :unmaintained

  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  # Backport fixes for ARM Sonoma
  patch do
    url "https://github.com/Snapchat/KeyDB/commit/674d9fb7eea1e6cca6ac8da3b2d1a63dc38c9d2b.patch?full_index=1"
    sha256 "aa175e61c8a8b5c12f8608afdb20985a558c14cc94f69be43ab3e0e0c999a3bc"
    type :backport
    resolves "https://github.com/Snapchat/KeyDB/pull/737"
  end
  patch do
    url "https://github.com/Snapchat/KeyDB/commit/603ebb27fb82a27fb98b0feb6749b0f7661a1c4b.patch?full_index=1"
    sha256 "3cece0a51cc74606bcfa32f1b745b615078be5c67ba3e97287ce9c5c982c1ba7"
    type :backport
    resolves "https://github.com/Snapchat/KeyDB/pull/801"
  end

  # Allow building with OpenSSL 4
  patch :DATA

  deny_network_access!

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/keydb-server --test-memory 2")
    assert_match "Your memory passed this test", output
  end
end

__END__
diff --git a/src/tls.cpp b/src/tls.cpp
index 8a8a97a95..fefc84df0 100644
--- a/src/tls.cpp
+++ b/src/tls.cpp
@@ -578,7 +578,7 @@ bool tlsCheckCertificateAgainstAllowlist(tls_connection* conn, std::set<sdsstrin
     TCleanup certClen([cert]{X509_free(cert);});
 
     /* Check the common name (CN) of the certificate first */
-    X509_NAME_ENTRY * ne = X509_NAME_get_entry(X509_get_subject_name(cert), X509_NAME_get_index_by_NID(X509_get_subject_name(cert), NID_commonName, -1));
+    const X509_NAME_ENTRY * ne = X509_NAME_get_entry(X509_get_subject_name(cert), X509_NAME_get_index_by_NID(X509_get_subject_name(cert), NID_commonName, -1));
     *commonName = reinterpret_cast<const char*>(ASN1_STRING_get0_data(X509_NAME_ENTRY_get_data(ne)));
 
     tlsSetCertificateFingerprint(conn, cert);
