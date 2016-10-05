class CppNetlib < Formula
  desc "C++ libraries for high level network programming"
  homepage "http://cpp-netlib.org"
  url "https://github.com/cpp-netlib/cpp-netlib/archive/cpp-netlib-0.12.0-final.tar.gz"
  version "0.12.0"
  sha256 "d66e264240bf607d51b8d0e743a1fa9d592d96183d27e2abdaf68b0a87e64560"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "39556f9094c27ba5891ce4efd189f291bf5e4e68d98bd80d9d94a68d809e3341" => :sierra
    sha256 "1823d6f6dfb79ef8a658ed867ca81f0ba21cd60954633c76585fcba1393954ef" => :el_capitan
    sha256 "7ab5e0a4dedba2954579394c98211b79680fe55acf8151a3a4ceb49971f27d25" => :yosemite
    sha256 "0bf00fa7b6f4fc414349b1ae221cd1aede049055b2c68734d9772fb95b73e535" => :mavericks
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
      "-lboost_system-mt",
      "-lcppnetlib-uri",
      "-lcppnetlib-client-connections",
      "-lcppnetlib-server-parsers",
    ] + ENV.cflags.split
    system ENV.cxx, "-o", "test", "test.cpp", *flags
    system "./test"
  end
end
