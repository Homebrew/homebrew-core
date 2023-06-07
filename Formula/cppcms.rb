class Cppcms < Formula
  include Language::Python::Shebang

  desc "Free High Performance Web Development Framework"
  homepage "http://cppcms.com/wikipp/en/page/main"
  url "https://downloads.sourceforge.net/project/cppcms/cppcms/1.2.1/cppcms-1.2.1.tar.bz2"
  sha256 "10fec7710409c949a229b9019ea065e25ff5687103037551b6f05716bf6cac52"

  livecheck do
    url :stable
    regex(%r{url=.*?/cppcms[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_ventura:  "04c25a7fa717d8459910082d31c4c77592a948580c74c76fe6f8acb6cfc750e5"
    sha256 cellar: :any,                 arm64_monterey: "9dde91368e8aa365794b238db7ea2b81a813e2c1cef36c3653b0cf20eff64491"
    sha256 cellar: :any,                 arm64_big_sur:  "45d52949a574fb1c9f469fe8fbf7da863d471c4ebd29b11a4c9097e38dbffba3"
    sha256 cellar: :any,                 ventura:        "abf6190b7e7e38b72f96e5ec2f08f55f5f5ebbaf89f994c5b2abacfdde805157"
    sha256 cellar: :any,                 monterey:       "aa3cfee1882aacf75885cddcb9d78511a6d467f3afd8b674702accbbe738cbd2"
    sha256 cellar: :any,                 big_sur:        "a13712969212fcca72e270d7490512782d6cce2da6112c916e11b4c0c7520ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd8b215d1f648697073f7c1e84d6cccb5f9d22330a8f13038bf82bcc64742270"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
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
