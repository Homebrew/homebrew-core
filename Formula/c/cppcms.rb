class Cppcms < Formula
  include Language::Python::Shebang

  desc "Free High Performance Web Development Framework"
  homepage "http://cppcms.com/wikipp/en/page/main"
  url "https://github.com/artyom-beilis/cppcms/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "1775beca6118a9908aa75e44f4f1174b62da8bee1ac2047ffb34897d64bc6bf5"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "d84ae7fbc5f5842ac9c3f059ad7f472b093e4bd064ead67613400b13c8256ac5"
    sha256 cellar: :any, arm64_tahoe:       "3e60d5df68d9b71a758c4d36e9eda5bd2c0e7e44336d19d676ad52b323b8f635"
    sha256 cellar: :any, arm64_sequoia:     "5124b51085eb6a99626cacc8beb377bd0d485b26dc17be5dfb9051581f9fd563"
    sha256 cellar: :any, arm64_linux:       "501e09db10d85110fd3b26e9af45cbf972957027a09b52dcde6101a1721baebd"
    sha256 cellar: :any, x86_64_linux:      "3c2715739b78e7d6b2e9a1cf3281e8fc28bcd75bff5065aba20ae2c6c0c0d24e"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"
  depends_on "pcre2"

  uses_from_macos "python"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "bin/cppcms_tmpl_cc"

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=11",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPYTHON=#{which("python3")}",
                    *std_cmake_args
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

    begin
      sleep 5 # grace time for server start
      assert_match "Hello World", shell_output("curl http://127.0.0.1:#{port}/hello")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
