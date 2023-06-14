class Cppcms < Formula
  include Language::Python::Shebang

  desc "Free High Performance Web Development Framework"
  homepage "http://cppcms.com/wikipp/en/page/main"
  url "https://downloads.sourceforge.net/project/cppcms/cppcms/1.2.1/cppcms-1.2.1.tar.bz2"
  sha256 "10fec7710409c949a229b9019ea065e25ff5687103037551b6f05716bf6cac52"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/cppcms[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1e231383932392067c2f82db565e7c89fdf262257dc18ae3c7069b661b7e37ad"
    sha256 cellar: :any,                 arm64_monterey: "fbe7cecff46a4e2bc8f799354a4fe510d195721e56c769f077a0573e54d71739"
    sha256 cellar: :any,                 arm64_big_sur:  "4bd9653322f70e9300800e2b221af694d228667967a6ee8df6069bc3496344af"
    sha256 cellar: :any,                 ventura:        "ae8964621f8e24d7494a9f7370dbbf4369a36e3dc0533632e101a6eb37adf4e1"
    sha256 cellar: :any,                 monterey:       "295e57a50103781f5f6d9d00f0693f8fa23802068fd53ee1fa0964bb1c9e556a"
    sha256 cellar: :any,                 big_sur:        "91451434afc317d71cee36e03047d170f453efcf4bcd61487750b353da4bb303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3abf8511c89ef7221ef752f3bc3bca222b89babd25605b33dae88d1584a0050b"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "python@3.11"

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
    (testpath/"hello.cpp").write <<~EOS
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
    EOS

    port = free_port
    (testpath/"config.json").write <<~EOS
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
    EOS
    system ENV.cxx, "hello.cpp", "-std=c++11", "-L#{lib}", "-lcppcms", "-o", "hello"
    pid = fork { exec "./hello", "-c", "config.json" }

    sleep 1 # grace time for server start
    begin
      assert_match "Hello World", shell_output("curl http://127.0.0.1:#{port}/hello")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
