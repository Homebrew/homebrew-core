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
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "798b916777f03da4b2ce560a2097cdcb1922b7bd3ac2800478654c4e9cd513f8"
    sha256 cellar: :any,                 arm64_monterey: "9a02f447ab6d82e0cf98c2a4aba48011974e6c6ae103cbe2e7c74890dac4d038"
    sha256 cellar: :any,                 arm64_big_sur:  "67a1c9feafceea6cbbe96ab29fa05ee6032dfc839b691cb3e64f28ebd8e70d81"
    sha256 cellar: :any,                 ventura:        "9b852a1493543e143f2561915b5f55ba9319695407af4d8f49cab73c850264a7"
    sha256 cellar: :any,                 monterey:       "d4b7c10f3349b0d96a29f936e1e26c819b99229bb0e49b3b6856c786be168418"
    sha256 cellar: :any,                 big_sur:        "4a343093b0050726543c1ca4e125460c5537efb7bb4c7ca24b475f8f33be12fe"
    sha256 cellar: :any,                 catalina:       "a0d3cb27c298bf95e97b7cbd97329aacd6eb33239f21dfe9e3d91272d5ce5263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1757391e77052508958f08bfe468e7168a6b8261f5022e9dd644de056e9079d"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "python@3.10"

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
