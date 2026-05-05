class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2026.04.27.00.tar.gz"
  sha256 "ae29a0210ac0a14315dc92072a20a31d472cd24fb7bb5abd133937db4306496c"
  license "Apache-2.0"
  revision 1
  compatibility_version 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "82fa8269ffedf4899b401541f6c42cc659e4089fb3fb10537b1f0258f1231ea4"
    sha256 cellar: :any,                 arm64_sequoia: "a7f1e54391675b9d25aa5a0e69b4b68cada075ee0fe7aa8409c4053292dff596"
    sha256 cellar: :any,                 arm64_sonoma:  "7e8de105530a82c3ee0c3cb31cc346b2ae904c221e31bcbfee045e2cc1688c38"
    sha256 cellar: :any,                 sonoma:        "168a89cd82705024bf584f4c980737c3cd1d163af046721e46193679e4f1ee2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fa881beed6c31eb2df5b9ea98abb702dcd8820bccdde5b3da96550417e72511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "292d131f86548293685cc1a62b77e7c017222400c61bdb975be022d7bc24115a"
  end

  depends_on "cmake" => :build
  depends_on "fast_float" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1100
    # https://github.com/facebook/folly/issues/1545
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  # Workaround for arm64 Linux error "Missing variable is: CMAKE_ASM_CREATE_SHARED_LIBRARY",
  # and OpenSSL 4 opaque ASN.1 APIs.
  # Ref: https://github.com/facebook/folly/pull/2562#issuecomment-3988207056
  patch :DATA

  def install
    args = %w[
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libfolly.a", "build/static/folly/libfollybenchmark.a"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++20", "test.cc", "-I#{include}", "-L#{lib}", "-lfolly", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/folly/external/aor/CMakeLists.txt b/folly/external/aor/CMakeLists.txt
index e07e58745..1429f54e9 100644
--- a/folly/external/aor/CMakeLists.txt
+++ b/folly/external/aor/CMakeLists.txt
@@ -20,6 +20,10 @@
 # Linux ELF directives (.size, etc.) that Darwin's assembler doesn't support
 if(IS_AARCH64_ARCH)
 
+if(BUILD_SHARED_LIBS)
+  set(CMAKE_ASM_CREATE_SHARED_LIBRARY ${CMAKE_C_CREATE_SHARED_LIBRARY})
+endif()
+
 folly_add_library(
   NAME memcpy_aarch64
   SRCS
diff --git a/folly/io/async/ssl/OpenSSLUtils.cpp b/folly/io/async/ssl/OpenSSLUtils.cpp
index 548ce3170..7f712fe48 100644
--- a/folly/io/async/ssl/OpenSSLUtils.cpp
+++ b/folly/io/async/ssl/OpenSSLUtils.cpp
@@ -122,8 +122,9 @@ bool OpenSSLUtils::validatePeerCertNames(
     auto name = sk_GENERAL_NAME_value(altNames, i);
     if ((addr4 != nullptr || addr6 != nullptr) && name->type == GEN_IPADD) {
       // Extra const-ness for paranoia
-      unsigned char const* const rawIpStr = name->d.iPAddress->data;
-      auto const rawIpLen = size_t(name->d.iPAddress->length);
+      unsigned char const* const rawIpStr =
+          ASN1_STRING_get0_data(name->d.iPAddress);
+      auto const rawIpLen = size_t(ASN1_STRING_length(name->d.iPAddress));
 
       if (rawIpLen == 4 && addr4 != nullptr) {
         if (::memcmp(rawIpStr, &addr4->sin_addr, rawIpLen) == 0) {
@@ -284,7 +285,7 @@
   if (x509 == nullptr) {
     return "";
   }
-  X509_NAME* subject = X509_get_subject_name(x509);
+  const X509_NAME* subject = X509_get_subject_name(x509);
   char buf[ub_common_name + 1];
   int length =
       X509_NAME_get_text_by_NID(subject, NID_commonName, buf, sizeof(buf));
diff --git a/folly/ssl/OpenSSLCertUtils.cpp b/folly/ssl/OpenSSLCertUtils.cpp
--- a/folly/ssl/OpenSSLCertUtils.cpp
+++ b/folly/ssl/OpenSSLCertUtils.cpp
@@ -31,7 +31,7 @@
   return std::string(errBuff.data());
 }
 
-std::string asn1ToString(ASN1_STRING* a) {
+std::string asn1ToString(const ASN1_STRING* a) {
   auto strType = ASN1_STRING_type(a);
   if (strType == V_ASN1_UTF8STRING || strType == V_ASN1_OCTET_STRING) {
     long len = ASN1_STRING_length(a);
@@ -49,9 +49,9 @@
   }
 }
 
-std::string getExtOid(X509_EXTENSION* extension) {
+std::string getExtOid(const X509_EXTENSION* extension) {
   CHECK_NOTNULL(extension);
-  ASN1_OBJECT* object = X509_EXTENSION_get_object(extension);
+  const ASN1_OBJECT* object = X509_EXTENSION_get_object(extension);
   // Query for extension OID
   constexpr int buf_size = 256;
   std::string ret(buf_size, '\0');
@@ -66,13 +66,13 @@
   return ret;
 }
 
-std::string getExtData(X509_EXTENSION* extension) {
+std::string getExtData(const X509_EXTENSION* extension) {
   CHECK_NOTNULL(extension);
   auto asnValue = X509_EXTENSION_get_data(extension);
   return asnValue ? asn1ToString(asnValue) : std::string();
 }
 
-Optional<std::string> commonName(X509_NAME* name) {
+Optional<std::string> commonName(const X509_NAME* name) {
   if (!name) {
     return none;
   }
@@ -214,7 +214,7 @@
     X509& x509, folly::StringPiece oid) {
   std::vector<std::string> extValues;
   for (int i = 0; i < X509_get_ext_count(&x509); i++) {
-    X509_EXTENSION* extension = X509_get_ext(&x509, i);
+    const X509_EXTENSION* extension = X509_get_ext(&x509, i);
     std::string extensionOid = getExtOid(extension);
     if (extensionOid == oid) {
       extValues.push_back(getExtData(extension));
@@ -227,7 +227,7 @@
 OpenSSLCertUtils::getAllExtensions(X509& x509) {
   std::vector<std::pair<std::string, std::string>> extensions;
   for (int i = 0; i < X509_get_ext_count(&x509); i++) {
-    X509_EXTENSION* extension = X509_get_ext(&x509, i);
+    const X509_EXTENSION* extension = X509_get_ext(&x509, i);
     std::string oid = getExtOid(extension);
     std::string value = getExtData(extension);
     extensions.push_back(std::make_pair(oid, value));
