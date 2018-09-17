class Cppcms < Formula
  desc "Free High Performance Web Development Framework"
  homepage "http://cppcms.com/wikipp/en/page/main"
  url "https://downloads.sourceforge.net/project/cppcms/cppcms/1.2.1/cppcms-1.2.1.tar.bz2"
  sha256 "10fec7710409c949a229b9019ea065e25ff5687103037551b6f05716bf6cac52"

  bottle do
    cellar :any
    sha256 "a8080faa8c88e67f769390bb4f2b7ea90f008551c35e8e9df8b926d32e8adb3a" => :mojave
    sha256 "9bb4d1f81736af36f781083a13ca6a17525ef14f331d60c308370978275d878b" => :high_sierra
    sha256 "ad90e817edf7dbec0cf35fecd3b8422bda8ceafc790a61f3c33d30f4e843d419" => :sierra
    sha256 "c42e2ea6f03634f436ae3bd3fb816ef3e0de10e86421fafa63b93f0d2005f957" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "pcre"

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
