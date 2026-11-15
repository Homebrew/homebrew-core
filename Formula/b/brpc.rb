class Brpc < Formula
  desc "Better RPC framework"
  homepage "https://brpc.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=brpc/1.18.0/apache-brpc-1.18.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/brpc/1.18.0/apache-brpc-1.18.0-src.tar.gz"
  sha256 "26497bb50a8e06c8ffe24f37325431b1ca72fffd447de6fa3eb0002db79c978a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/brpc.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "674826278d5fd23ec322f14a494ee28884663dc548ace8a2362b1d107cdf9927"
    sha256 cellar: :any, arm64_tahoe:       "c3ff2d5a555aa3001f0dc4e29c634c3e291e329eef0625c2628a8f3ee670520c"
    sha256 cellar: :any, arm64_sequoia:     "5430935e44918fafa8b2745d45e64784595da8fb95cd9f7b70b030c09578d626"
    sha256               arm64_linux:       "0679768c2bdd43169cf7b65463a951496d137d5504a827ec42a469f40bda2bfb"
    sha256               x86_64_linux:      "d9bd3f04240649cc2c9c8c8ca824190f67616d934b7888ccbd15b6a20e66bb5c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "abseil"
  depends_on "gflags"
  depends_on "leveldb"
  depends_on "openssl@4"
  depends_on "protobuf"

  # Apply OpenSSL 4 fix from https://github.com/apache/brpc/pull/3616
  patch :DATA

  allow_network_access! :test

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_UNIT_TESTS=OFF
      -DDOWNLOAD_GTEST=OFF
      -DWITH_DEBUG_SYMBOLS=OFF
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@4")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>

      #include <brpc/channel.h>
      #include <brpc/controller.h>
      #include <butil/logging.h>

      int main() {
        brpc::Channel channel;
        brpc::ChannelOptions options;
        options.protocol = "http";
        options.timeout_ms = 1000;
        if (channel.Init("https://brew.sh/", &options) != 0) {
          LOG(ERROR) << "Failed to initialize channel";
          return 1;
        }
        brpc::Controller cntl;
        cntl.http_request().uri() = "https://brew.sh/";
        channel.CallMethod(nullptr, &cntl, nullptr, nullptr, nullptr);
        if (cntl.Failed()) {
          LOG(ERROR) << cntl.ErrorText();
          return 1;
        }
        std::cout << cntl.http_response().status_code();
        return 0;
      }
    CPP

    protobuf = Formula["protobuf"]
    flags = %W[
      -I#{include}
      -I#{protobuf.opt_include}
      -L#{lib}
      -L#{protobuf.opt_lib}
      -lbrpc
      -lprotobuf
    ]
    # Work around for undefined reference to symbol
    # '_ZN4absl12lts_2024072212log_internal21CheckOpMessageBuilder7ForVar2Ev'
    flags += shell_output("pkgconf --libs absl_log_internal_check_op").chomp.split

    system ENV.cxx, "-std=gnu++17", "test.cpp", "-o", "test", *flags
    assert_equal "200", shell_output("./test")
  end
end

__END__
diff --git a/src/brpc/details/ssl_helper.cpp b/src/brpc/details/ssl_helper.cpp
index 1673db1d87..25ee4c6a83 100644
--- a/src/brpc/details/ssl_helper.cpp
+++ b/src/brpc/details/ssl_helper.cpp
@@ -287,10 +287,10 @@ void ExtractHostnames(X509* x, std::vector<std::string>* hostnames) {
 #endif // SSL_CTRL_SET_TLSEXT_HOSTNAME 
 
     int i = -1;
-    X509_NAME* xname = X509_get_subject_name(x);
+    auto* xname = X509_get_subject_name(x);
     while ((i = X509_NAME_get_index_by_NID(xname, NID_commonName, i)) != -1) {
         char* str = nullptr;
-        X509_NAME_ENTRY* entry = X509_NAME_get_entry(xname, i);
+        auto* entry = X509_NAME_get_entry(xname, i);
         const int len = ASN1_STRING_to_UTF8((unsigned char**)&str, 
                                             X509_NAME_ENTRY_get_data(entry));
         if (len >= 0) {
