class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/Microsoft/cpprestsdk"
  # pull from git tag to get submodules
  url "https://github.com/Microsoft/cpprestsdk.git",
      tag:      "v2.10.19",
      revision: "411a109150b270f23c8c97fa4ec9a0a4a98cdecf"
  license "MIT"
  head "https://github.com/Microsoft/cpprestsdk.git", branch: "development"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "252c1e2ad5f0123d2b31840601166a73bd72bfbc229792d54aa73d920948331e"
    sha256 cellar: :any,                 arm64_ventura:  "93818f470b5411b1696aa60e04a31f42cabef407d05a26e937e24c2a467da693"
    sha256 cellar: :any,                 arm64_monterey: "e4f4298398119a07041429688116832f67b33c4c9775ab1722a30c287125f8b6"
    sha256 cellar: :any,                 sonoma:         "0bb14c095957af12e08500e024739f78176f6361ff90c5efdda5e682613cffae"
    sha256 cellar: :any,                 ventura:        "14bb46f094fa800b287ad3f960de71cf0a401005e4bc552176dd8d585e107540"
    sha256 cellar: :any,                 monterey:       "b6de216686c055332e5e6d2bcf36a4aff430f1e2121f3adfd59b9ed337a6bea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e55392240623fb92f5f42a22d790950d856fd4a0416d90e9f1c721c3197ef80"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-DBUILD_SAMPLES=OFF", "-DBUILD_TESTS=OFF",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"]}.opt_prefix",
                    "Release", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <cpprest/http_client.h>
      int main() {
        web::http::client::http_client client(U("https://example.com/"));
        std::cout << client.request(web::http::methods::GET).get().extract_string().get() << std::endl;
      }
    EOS
    system ENV.cxx, "test.cc", "-std=c++11",
                    "-I#{Formula["boost"].include}", "-I#{Formula["openssl@3"].include}", "-I#{include}",
                    "-L#{Formula["boost"].lib}", "-L#{Formula["openssl@3"].lib}", "-L#{lib}",
                    "-lssl", "-lcrypto", "-lboost_random-mt", "-lboost_chrono-mt", "-lboost_thread-mt",
                    "-lboost_system-mt", "-lboost_filesystem-mt", "-lcpprest",
                    "-o", "test_cpprest"
    assert_match "<title>Example Domain</title>", shell_output("./test_cpprest")
  end
end
