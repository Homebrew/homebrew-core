class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/Microsoft/cpprestsdk"
  # pull from git tag to get submodules
  url "https://github.com/Microsoft/cpprestsdk.git",
      :tag      => "v2.10.15",
      :revision => "b94bc32ff84e815ba44c567f6fe4af5f5f6b3048"
  head "https://github.com/Microsoft/cpprestsdk.git", :branch => "development"

  bottle do
    cellar :any
    sha256 "4b81bff905939ccfdce5d58c94e43f9853986ea54925c9ebafc8fd4d8cfcfba6" => :catalina
    sha256 "7947cbaf52d95183265440e7b36bbe479f99855ffee13b14ba602d85f10a6e5a" => :mojave
    sha256 "7071f74a30f5aeff050e40240f416942deba245d68ca624600206819be5e0dbb" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@1.1"

  # Fix for boost 1.70.0 https://github.com/microsoft/cpprestsdk/issues/1054
  # From websocketpp pull request https://github.com/zaphoyd/websocketpp/pull/814
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/cpprestsdk/2.10.14.diff"
    sha256 "fdfd1d6c3108bd463f3a6e3c8056a4f82268d6def1867b5fbbd9682f617c8c25"
  end

  def install
    system "cmake", "-DBUILD_SAMPLES=OFF", "-DBUILD_TESTS=OFF", "Release", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <cpprest/http_client.h>
      int main() {
        web::http::client::http_client client(U("https://github.com/"));
        std::cout << client.request(web::http::methods::GET).get().extract_string().get() << std::endl;
      }
    EOS
    flags = ["-stdlib=libc++", "-std=c++11", "-I#{include}",
             "-I#{Formula["boost"].include}",
             "-I#{Formula["openssl@1.1"].include}", "-L#{lib}",
             "-L#{Formula["openssl@1.1"].lib}", "-L#{Formula["boost"].lib}",
             "-lssl", "-lcrypto", "-lboost_random", "-lboost_chrono",
             "-lboost_thread-mt", "-lboost_system-mt", "-lboost_regex",
             "-lboost_filesystem", "-lcpprest"] + ENV.cflags.to_s.split
    system ENV.cxx, "-o", "test_cpprest", "test.cc", *flags
    system "./test_cpprest"
  end
end
