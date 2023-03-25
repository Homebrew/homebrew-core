class Curlcpp < Formula
  desc "Object oriented C++ wrapper for CURL (libcurl)"
  homepage "https://josephp91.github.io/curlcpp"
  url "https://github.com/JosephP91/curlcpp/archive/refs/tags/3.0.tar.gz"
  sha256 "fcb78774c493ca8f7fa51741dd75d43c8a5a04a788b47e44216ca4d9cf672344"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "055289b47dfd3b9a721428a523dc53275ffe62be335fb781842babdadbbb3a8b"
    sha256 cellar: :any,                 arm64_monterey: "e785e0544a18e69ce91160e8d9aee8cb98c013d0248e525d4d1afe91cdbda7dd"
    sha256 cellar: :any,                 arm64_big_sur:  "8614c80879657ce43422decf23f60ad618f49c8ba0deab9562923016be6fb438"
    sha256 cellar: :any,                 ventura:        "1c3aefe7b8079eb121525b56d9a92bcf142f8a9e0c26a74fa77611644f9ab95f"
    sha256 cellar: :any,                 monterey:       "beeffe3a8998bf761415fdce1769d3759699f4a351c0d176de5efa09403be04f"
    sha256 cellar: :any,                 big_sur:        "e3e44fe68b423dfab2442f0f9452ee259203a3ad79bf19df6c6a2581bebe08c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "449926e50c62f027bdb3053e5c5d514c0ef06668fb8541beed40ea0f93d2f381"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=SHARED"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <ostream>

      #include "curlcpp/curl_easy.h"
      #include "curlcpp/curl_form.h"
      #include "curlcpp/curl_ios.h"
      #include "curlcpp/curl_exception.h"

      using std::cout;
      using std::endl;
      using std::ostringstream;

      using curl::curl_easy;
      using curl::curl_ios;
      using curl::curl_easy_exception;
      using curl::curlcpp_traceback;

      int main() {
          // Create a stringstream object
          ostringstream str;
          // Create a curl_ios object, passing the stream object.
          curl_ios<ostringstream> writer(str);

          // Pass the writer to the easy constructor and watch the content returned in that variable!
          curl_easy easy(writer);
          easy.add<CURLOPT_URL>("https://google.com");
          easy.add<CURLOPT_FOLLOWLOCATION>(1L);

          try {
              easy.perform();
          } catch (curl_easy_exception &error) {
              // If you want to print the last error.
              std::cerr<<error.what()<<std::endl;

              // If you want to print the entire error stack you can do
              error.print_traceback();
          }
          return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lcurlcpp", "-lcurl", "-o", "test"
    system "./test"
  end
end
