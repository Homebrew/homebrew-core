class CppNetlib < Formula
  desc "C++ libraries for high level network programming"
  homepage "http://cpp-netlib.org"
  url "http://downloads.cpp-netlib.org/0.12.0/cpp-netlib-0.12.0-final.tar.gz"
  version "0.12.0"
  sha256 "a0a4a5cbb57742464b04268c25b80cc1fc91de8039f7710884bf8d3c060bd711"

  bottle do
    cellar :any_skip_relocation
    sha256 "31f104305120902459602057fd3f8d294cf6baba74245b7f60d0830b8b297313" => :el_capitan
    sha256 "c7a2a371cd3baea1db61bc6027b5bf2e0456a3241bbc9f069339be8e02ddf75c" => :yosemite
    sha256 "763ea06bd9e627c6ce4f219dab8b75c7b33b748885555e0765f76e3e1a4b10fc" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "asio"

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  needs :cxx11

  def install
    ENV.cxx11

    # NB: Do not build examples or tests as they require submodules.
    system "cmake", "-DCPP-NETLIB_BUILD_TESTS=OFF", "-DCPP-NETLIB_BUILD_EXAMPLES=OFF", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <boost/network/protocol/http/client.hpp>
      int main(int argc, char *argv[]) {
        namespace http = boost::network::http;
        http::client::options options;
        http::client client(options);
        http::client::request request("");
        return 0;
      }
    EOS
    flags = [
      "-std=c++11",
      "-stdlib=libc++",
      "-I#{include}",
      "-I#{Formula["asio"].include}",
      "-I#{Formula["boost"].include}",
      "-L#{lib}",
      "-L#{Formula["boost"].lib}",
      "-lssl",
      "-lcrypto",
      "-lboost_thread-mt",
      "-lboost_system-mt",
      "-lcppnetlib-uri",
      "-lcppnetlib-client-connections",
      "-lcppnetlib-server-parsers",
    ] + ENV.cflags.split
    system ENV.cxx, "-o", "test", "test.cpp", *flags
    system "./test"
  end
end
