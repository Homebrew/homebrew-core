class Curlcpp < Formula
  desc "Object oriented C++ wrapper for CURL (libcurl)"
  homepage "https://josephp91.github.io/curlcpp"
  url "https://github.com/JosephP91/curlcpp/archive/refs/tags/3.1.tar.gz"
  sha256 "ba7aeed9fde9e5081936fbe08f7a584e452f9ac1199e5fabffbb3cfc95e85f4b"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe8f2d32c516113abdc6caa797a8d42f11ca2aa9fbb618043ec76cbbab0749a1"
    sha256 cellar: :any,                 arm64_sequoia: "c436767f9b31dfaf4bcb0b173c8a05c338954f2cfe310cc6a5a4b0abd07f19e1"
    sha256 cellar: :any,                 arm64_sonoma:  "cf6ac3204eff880beee1d8e79aad0fcff5df2a9a9c7599b969a313892ea0d579"
    sha256 cellar: :any,                 arm64_ventura: "fc4bb565327be35db477f5c94e99ac541107af06b9139a42484aba7f631c00b2"
    sha256 cellar: :any,                 sonoma:        "38e40220123c5b9ffde970e0ba30d802b54caef5782019935677f597829ec37a"
    sha256 cellar: :any,                 ventura:       "5676d84a6ce7dc9f2a65f19cb8752ca24f5f974c27d315e421b7ca1e82bdcdbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15859545f41a80de5e299a010837b61f5c9b6cd77f9433ab595061009f932737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7b8f28ef1d8782146a24e1687c1044b5f10149c721b098bf4514f8186b9649d"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  # remove use of CURLOPT_CLOSEPOLICY (removed since curl 8.10+), upstream pr ref, https://github.com/JosephP91/curlcpp/pull/159
  patch do
    on_linux do
      url "https://github.com/JosephP91/curlcpp/commit/bc3800510f30ed74c90227b166d134cd13fd63cf.patch?full_index=1"
      sha256 "0954b32d0304ad9b4acecf3f647242b2c5736f4c6576a390e665e57883dcf10f"
    end
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=SHARED", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lcurlcpp", "-lcurl", "-o", "test"
    system "./test"
  end
end
