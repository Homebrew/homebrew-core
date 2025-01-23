class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/microsoft/cpprestsdk"
  # pull from git tag to get submodules
  url "https://github.com/microsoft/cpprestsdk.git",
      tag:      "v2.10.19",
      revision: "411a109150b270f23c8c97fa4ec9a0a4a98cdecf"
  license "MIT"
  revision 1
  head "https://github.com/microsoft/cpprestsdk.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e414a002007eba0a4606f30cc11817338e1287f720d623a616f7e46524717479"
    sha256 cellar: :any,                 arm64_sonoma:  "ca0b2b79e8165896f68903d6307ad3aa3f01116f952ce0c36074840852cb2ded"
    sha256 cellar: :any,                 arm64_ventura: "52897f579904d7bd14996e47e0344d779939936dc96b6ff066d76bbd972b90bc"
    sha256 cellar: :any,                 sonoma:        "5b13e9fd406f3807679d8e193ca8ae4b9bb183a536e3c6add15fe7be7e4806a0"
    sha256 cellar: :any,                 ventura:       "1c7a0ec58aefff285cc161f38fa77b1b7f5c1a62b4c36c85f1bd6d037c932fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06c8025f11aa65e2d9f0694d5a6d530b292d4eb77bec724105c3849dd1254e45"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost@1.85" # Issue ref: https://github.com/microsoft/cpprestsdk/issues/1323
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", "Release", "-B", "build",
                    "-DBUILD_SAMPLES=OFF",
                    "-DBUILD_TESTS=OFF",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <iostream>
      #include <cpprest/http_client.h>
      int main() {
        web::http::client::http_client client(U("https://example.com/"));
        std::cout << client.request(web::http::methods::GET).get().extract_string().get() << std::endl;
      }
    CPP
    boost = Formula["boost@1.85"]
    system ENV.cxx, "test.cc", "-std=c++11",
                    "-I#{boost.include}", "-I#{Formula["openssl@3"].include}", "-I#{include}",
                    "-L#{boost.lib}", "-L#{Formula["openssl@3"].lib}", "-L#{lib}",
                    "-lssl", "-lcrypto", "-lboost_random-mt", "-lboost_chrono-mt", "-lboost_thread-mt",
                    "-lboost_system-mt", "-lboost_filesystem-mt", "-lcpprest",
                    "-o", "test_cpprest"
    assert_match "<title>Example Domain</title>", shell_output("./test_cpprest")
  end
end
