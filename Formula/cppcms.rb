class Cppcms < Formula
  desc "Free High Performance Web Development Framework"
  homepage "http://cppcms.com/wikipp/en/page/main"
  url "https://downloads.sourceforge.net/project/cppcms/cppcms/1.2.0/cppcms-1.2.0.tar.bz2"
  sha256 "a5a29603269ab65d86f159cce342fba896a9316998a924e2e9f2b65dab9b70b9"

  bottle do
    cellar :any
    sha256 "744ccb4f774905696f3944f40a28ba152d4d5770335ec89bf2160c29f4903ad7" => :high_sierra
    sha256 "814470be47e6f70e34970257cf238b60237050a5e649df7cba8a5aaa478c65dc" => :sierra
    sha256 "6c752408d44ccb5c516b3bef5185515001cc9fff639a2f9e243386b64c8c7cba" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pcre"
  depends_on "openssl"

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", *std_cmake_args
    system "make", "install"
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

    (testpath/"config.json").write <<~EOS
      {
          "service" : {
              "api" : "http",
              "port" : 8080,
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
    system ENV.cxx, "-o", "hello", "-std=c++11", "-stdlib=libc++", "-lc++",
                    "-L#{lib}", "-lcppcms", "hello.cpp"
    pid = fork { exec "./hello", "-c", "config.json" }

    sleep 1 # grace time for server start
    begin
      assert_match(/Hello World/, shell_output("curl http://127.0.0.1:8080/hello"))
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
