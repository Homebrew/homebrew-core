class Osquery < Formula
  desc "SQL powered operating system instrumentation and analytics"
  homepage "https://osquery.io"
  url "https://github.com/facebook/osquery/archive/3.3.2.tar.gz"
  sha256 "74280181f45046209053a3e15114d93adc80929a91570cc4497931cfb87679e4"
  revision 7

  bottle do
    cellar :any
    sha256 "16662c8d802d1b14b8fe51b4bd42707cf556e6567a86f2bb2886204ce68b5ab9" => :catalina
    sha256 "1480020e674965e23dd59cd6dee6ad2209d55b839c958ff236c525a8a57a7ba2" => :mojave
    sha256 "32a3852dbd1f226a30d2c6003b1c1397ef49c4339eb17bda466bf1f982fc4ee3" => :high_sierra
    sha256 "75f51a577ccfa48c10b8af7d5f7cd766fc133784b74cd26eb46529fa64553d62" => :sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "python" => :build
  depends_on "augeas"
  depends_on "boost"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "librdkafka"
  depends_on "lldpd"
  # osquery only supports macOS 10.12 and above. Do not remove this.
  depends_on :macos => :sierra
  depends_on "openssl@1.1"
  depends_on "rapidjson"
  depends_on "rocksdb"
  depends_on "sleuthkit"
  depends_on "ssdeep"
  depends_on "thrift"
  depends_on "xz"
  depends_on "yara"
  depends_on "zstd"

  fails_with :gcc => "6"

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/5f/bd/5815d4d925a2b8cbbb4b4960f018441b0c65f24ba29f3bdcfb3c8218a307/Jinja2-2.8.1.tar.gz"
    sha256 "35341f3a97b46327b3ef1eb624aadea87a535b8f50863036e085e7c426ac5891"
  end

  resource "third-party" do
    url "https://github.com/osquery/third-party/archive/3.0.0.tar.gz"
    sha256 "98731b92147f6c43f679a4a9f63cbb22f2a4d400d94a45e308702dee66a8de9d"
  end

  resource "aws-sdk-cpp" do
    url "https://github.com/aws/aws-sdk-cpp/archive/1.4.55.tar.gz"
    sha256 "0a70c2998d29cc4d8a4db08aac58eb196d404073f6586a136d074730317fe408"
  end

  # Upstream fix for boost 1.69, remove in next version
  # https://github.com/facebook/osquery/pull/5496
  patch do
    url "https://github.com/facebook/osquery/commit/130b3b3324e2.diff?full_index=1"
    sha256 "46bce0c62f1a8f0df506855049991e6fceb6d1cc4e1113a2f657e76b5c5bdd14"
  end

  # Patch for compatibility with OpenSSL 1.1
  # submitted upstream: https://github.com/osquery/osquery/issues/5755
  patch :DATA

  def install
    ENV.cxx11

    vendor = buildpath/"brew_vendor"

    resource("aws-sdk-cpp").stage do
      args = std_cmake_args + %W[
        -DSTATIC_LINKING=1
        -DNO_HTTP_CLIENT=1
        -DMINIMIZE_SIZE=ON
        -DBUILD_SHARED_LIBS=OFF
        -DBUILD_ONLY=ec2;firehose;kinesis;sts
        -DCMAKE_INSTALL_PREFIX=#{vendor}/aws-sdk-cpp
      ]

      mkdir "build" do
        system "cmake", "..", *args
        system "make"
        system "make", "install"
      end
    end

    # Skip test and benchmarking.
    ENV["SKIP_TESTS"] = "1"
    ENV["SKIP_DEPS"] = "1"

    # Skip SMART drive tables.
    # SMART requires a dependency that isn't packaged by brew.
    ENV["SKIP_SMART"] = "1"

    # Link dynamically against brew-installed libraries.
    ENV["BUILD_LINK_SHARED"] = "1"
    # Set the version
    ENV["OSQUERY_BUILD_VERSION"] = version

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", buildpath/"third-party/python/lib/python#{xy}/site-packages"

    res = resources.map(&:name).to_set - %w[aws-sdk-cpp third-party]
    res.each do |r|
      resource(r).stage do
        system "python3", "setup.py", "install",
                          "--prefix=#{buildpath}/third-party/python/",
                          "--single-version-externally-managed",
                          "--record=installed.txt"
      end
    end

    cxx_flags_release = %W[
      -DNDEBUG
      -I#{MacOS.sdk_path}/usr/include/libxml2
      -I#{vendor}/aws-sdk-cpp/include
    ]

    args = std_cmake_args + %W[
      -Daws-cpp-sdk-core_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-core.a
      -Daws-cpp-sdk-firehose_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-firehose.a
      -Daws-cpp-sdk-kinesis_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-kinesis.a
      -Daws-cpp-sdk-sts_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-sts.a
      -DCMAKE_CXX_FLAGS_RELEASE:STRING=#{cxx_flags_release.join(" ")}
    ]

    (buildpath/"third-party").install resource("third-party")

    system "cmake", ".", *args
    system "make"
    system "make", "install"
    (include/"osquery/core").install Dir["osquery/core/*.h"]
  end

  plist_options :startup => true, :manual => "osqueryd"

  test do
    assert_match "platform_info", shell_output("#{bin}/osqueryi -L")
  end
end
__END__
diff -pur osquery-3.3.2/osquery/tables/system/darwin/certificates.mm osquery-3.3.2-fixed/osquery/tables/system/darwin/certificates.mm
--- osquery-3.3.2/osquery/tables/system/darwin/certificates.mm	2018-10-29 22:24:29.000000000 +0100
+++ osquery-3.3.2-fixed/osquery/tables/system/darwin/certificates.mm	2019-09-07 16:25:24.000000000 +0200
@@ -20,6 +20,7 @@ namespace tables {

 void genCertificate(X509* cert, const std::string& path, QueryData& results) {
   Row r;
+  const ASN1_OCTET_STRING *s;

   // Generate the common name and subject.
   // They are very similar OpenSSL API accessors so save some logic and
@@ -42,13 +43,11 @@ void genCertificate(X509* cert, const st
   // so it should be called before others.
   r["ca"] = (CertificateIsCA(cert)) ? INTEGER(1) : INTEGER(0);
   r["self_signed"] = (CertificateIsSelfSigned(cert)) ? INTEGER(1) : INTEGER(0);
-  r["key_usage"] = genKeyUsage(cert->ex_kusage);
-  r["authority_key_id"] =
-      (cert->akid && cert->akid->keyid)
-          ? genKIDProperty(cert->akid->keyid->data, cert->akid->keyid->length)
-          : "";
-  r["subject_key_id"] =
-      (cert->skid) ? genKIDProperty(cert->skid->data, cert->skid->length) : "";
+  r["key_usage"] = genKeyUsage(X509_get_key_usage(cert));
+  s = X509_get0_authority_key_id(cert);
+  r["authority_key_id"] = s ? genKIDProperty(s->data, s->length) : "";
+  s = X509_get0_subject_key_id(cert);
+  r["subject_key_id"] = s ? genKIDProperty(s->data, s->length) : "";

   r["serial"] = genSerialForCertificate(cert);

diff -pur osquery-3.3.2/osquery/tables/system/darwin/keychain_utils.cpp osquery-3.3.2-fixed/osquery/tables/system/darwin/keychain_utils.cpp
--- osquery-3.3.2/osquery/tables/system/darwin/keychain_utils.cpp	2018-10-29 22:24:29.000000000 +0100
+++ osquery-3.3.2-fixed/osquery/tables/system/darwin/keychain_utils.cpp	2019-09-07 17:03:59.000000000 +0200
@@ -84,7 +84,10 @@ void genAlgorithmProperties(X509* cert,
                             std::string& sig,
                             std::string& size) {
   int nid = 0;
-  nid = OBJ_obj2nid(cert->cert_info->key->algor->algorithm);
+  ASN1_OBJECT *ppkalg;
+  X509_PUBKEY *pubkey = X509_get_X509_PUBKEY(cert);
+  X509_PUBKEY_get0_param(&ppkalg, NULL, NULL, NULL, pubkey);
+  nid = OBJ_obj2nid(ppkalg);
   if (nid != NID_undef) {
     key = std::string(OBJ_nid2ln(nid));

@@ -101,7 +104,7 @@ void genAlgorithmProperties(X509* cert,
       // The EVP_size for EC keys returns the maximum buffer for storing the
       // key data, it does not indicate the size/strength of the curve.
       if (nid == NID_X9_62_id_ecPublicKey) {
-        const EC_KEY* ec_pkey = pkey->pkey.ec;
+        const EC_KEY* ec_pkey = EVP_PKEY_get0_EC_KEY(pkey);
         const EC_GROUP* ec_pkey_group = nullptr;
         ec_pkey_group = EC_KEY_get0_group(ec_pkey);
         int curve_nid = 0;
@@ -114,7 +117,7 @@ void genAlgorithmProperties(X509* cert,
     EVP_PKEY_free(pkey);
   }

-  nid = OBJ_obj2nid(cert->cert_info->signature->algorithm);
+  nid = OBJ_obj2nid(X509_get0_tbs_sigalg(cert)->algorithm);
   if (nid != NID_undef) {
     sig = std::string(OBJ_nid2ln(nid));
   }
