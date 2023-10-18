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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "685b90ed09888777bc4de5cc805780a843875f6703b8ea9c1e6bdcd89fbb19ba"
    sha256 cellar: :any,                 arm64_ventura:  "f68675a3347dfe88a996f0ad925f35f62552d23765c7a0edd512d836cce06b43"
    sha256 cellar: :any,                 arm64_monterey: "4c70578f35d994cf48783db520a152ce49a5c0cd877e37632a2254a2a9bdbe7e"
    sha256 cellar: :any,                 sonoma:         "e05d50189df26fab05f6fddc95c3f0a0f8355dc0e049a9b8a47c94d5557274bd"
    sha256 cellar: :any,                 ventura:        "0e14603d5eef7838b03cbf3dd59cb61ffb284150dd3a21a1bbcfc3493a1456d6"
    sha256 cellar: :any,                 monterey:       "500746081d5faad30d230618d3a71b97d8332ed6476752bdbf1e3e81b44e262c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b87fe3b52ead0794e23882355a33ffae08c1dd340d0b3710cb769e1dba7edb8"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "python@3.12"

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
