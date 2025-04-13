class Cppcms < Formula
  include Language::Python::Shebang

  desc "Free High Performance Web Development Framework"
  homepage "http://cppcms.com/wikipp/en/page/main"
  url "https://downloads.sourceforge.net/project/cppcms/cppcms/1.2.1/cppcms-1.2.1.tar.bz2"
  sha256 "10fec7710409c949a229b9019ea065e25ff5687103037551b6f05716bf6cac52"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/cppcms[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "15a16c5b5f573a43871ff8c74cc01c314fb0e4972d4c70ca7f168c662bf20ef5"
    sha256 cellar: :any,                 arm64_sonoma:  "40b9a78d35c4a82ca461589a699a578b9af04a2db0bd04e996585bd4caab6b00"
    sha256 cellar: :any,                 arm64_ventura: "fd4431e3606205326aec8f484f3244201795ac5d23343489bcbebcee30dab312"
    sha256 cellar: :any,                 sonoma:        "fa701ccf8fdb79cdef8b0a690ef5f77f167d63568349aefaca9ede863a3b16f1"
    sha256 cellar: :any,                 ventura:       "adc2a352809a202ca39cfa42ca5674512311d7e58a13bb1a4db8e844bfb7b310"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e32e87d6fd92a34b980782479476ec19d5c7e153cc81f5c002d0ce578f9ac35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1882da73e8db41b00a7fa01095d3d59314814cbaeb351e8cb7ca6611d44c02c2"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "python@3.13"

  uses_from_macos "zlib"

  def install
    ENV.cxx11

    # Look explicitly for python3 and ignore python2
    inreplace "CMakeLists.txt", "find_program(PYTHON NAMES python2 python)", "find_program(PYTHON NAMES python3)"

    # Adjust cppcms_tmpl_cc for Python 3 compatibility (and rewrite shebang to use brewed Python)
    rewrite_shebang detected_python_shebang, "bin/cppcms_tmpl_cc"
    inreplace "bin/cppcms_tmpl_cc" do |s|
      s.gsub! "import StringIO", "import io"
      s.gsub! "StringIO.StringIO()", "io.StringIO()"
      s.gsub! "md5(header_define)", "md5(header_define.encode('utf-8'))"
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.cpp").write <<~CPP
      #include <cppcms/application.h>
      #include <cppcms/applications_pool.h>
      #include <cppcms/service.h>
      #include <cppcms/http_response.h>
      #include <iostream>
      #include <string>

      class hello : public cppcms::application {
          public:
              hello(cppcms::service& srv): cppcms::application(srv) {}
              virtual void main(std::string url);
      };

      void hello::main(std::string /*url*/)
      {
          response().out() <<
              "<html>\\n"
              "<body>\\n"
              "  <h1>Hello World</h1>\\n"
              "</body>\\n"
              "</html>\\n";
      }

      int main(int argc,char ** argv)
      {
          try {
              cppcms::service srv(argc,argv);
              srv.applications_pool().mount(
                cppcms::applications_factory<hello>()
              );
              srv.run();
              return 0;
          }
          catch(std::exception const &e) {
              std::cerr << e.what() << std::endl;
              return -1;
          }
      }
    CPP

    port = free_port
    (testpath/"config.json").write <<~JSON
      {
          "service" : {
              "api" : "http",
              "port" : #{port},
              "worker_threads": 1
          },
          "daemon" : {
              "enable" : false
          },
          "http" : {
              "script_names" : [ "/hello" ]
          }
      }
    JSON
    system ENV.cxx, "hello.cpp", "-std=c++11", "-L#{lib}", "-lcppcms", "-o", "hello"
    pid = spawn "./hello", "-c", "config.json"

    sleep 5 # grace time for server start
    begin
      assert_match "Hello World", shell_output("curl http://127.0.0.1:#{port}/hello")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
