class Cppcms < Formula
  desc "Free High Performance Web Development Framework"
  homepage "http://cppcms.com/wikipp/en/page/main"
  url "https://downloads.sourceforge.net/project/cppcms/cppcms/1.2.1/cppcms-1.2.1.tar.bz2"
  sha256 "10fec7710409c949a229b9019ea065e25ff5687103037551b6f05716bf6cac52"

  bottle do
    cellar :any
    rebuild 1
    sha256 "14a71b7ff0bbcbd0def75bd0a5e4552d5bfeccd24b7de17d38dcb676c37a71cf" => :catalina
    sha256 "aa587cdc614e7450100ee7c9aef5259893db98db66b9aa3fce8bc928fe080de7" => :mojave
    sha256 "3339592fd6caed70941abe444cf34c1621dd65878eea1acbd07e798d4bb5c9b4" => :high_sierra
    sha256 "9f21d55044af09d3eced9664c2d570657f0b3221c9f3051a5311f6f197bd2a28" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"

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
