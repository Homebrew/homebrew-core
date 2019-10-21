class Cpprestsdk < Formula
  desc "C++ libraries for cloud-based client-server communication"
  homepage "https://github.com/Microsoft/cpprestsdk"
  # pull from git tag to get submodules
  url "https://github.com/Microsoft/cpprestsdk.git",
      :tag      => "v2.10.14",
      :revision => "6f602bee67b088a299d7901534af3bce6334ab38"
  revision 1
  head "https://github.com/Microsoft/cpprestsdk.git", :branch => "development"

  bottle do
    cellar :any
    sha256 "b4e95a61678b159d693c5fa8f30ad5e234b6f8c81ee811e80094aa8eac58ebd5" => :catalina
    sha256 "2b8117876aa647899436583bfed1008ae58c1cab42e8f9bf8a486672fcf50293" => :mojave
    sha256 "e662c92e6525fc3ca1f68bff3fea5d8c789e9e0dddec494ec25736d958cdd5ad" => :high_sierra
    sha256 "c68b6d8dbdbfc14d223cde0c310384994ed113ad0f5a688391e245d94f580703" => :sierra
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
