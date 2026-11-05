class Cppcms < Formula
  include Language::Python::Shebang

  desc "Free High Performance Web Development Framework"
  homepage "http://cppcms.com/wikipp/en/page/main"
  url "https://github.com/artyom-beilis/cppcms/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "1775beca6118a9908aa75e44f4f1174b62da8bee1ac2047ffb34897d64bc6bf5"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0d193ab4a71fec4a93c39b200b9208511d62f4265b99cea957091b8630698c91"
    sha256 cellar: :any, arm64_tahoe:       "fdbe60780dff88f91746b900e55406d3882aa7aa2a6c44a1823cebc5e1640c51"
    sha256 cellar: :any, arm64_sequoia:     "0e022eb61efcd8345ff984e1978dabee687bea4a071c22cdcd1c595050a45e5c"
    sha256 cellar: :any, arm64_linux:       "6968bb4e80c512a3dace6e211b061abfd023a5b2c43f31eb843bc4a2082c2bde"
    sha256 cellar: :any, x86_64_linux:      "14aa9e648c3bb21136239bd4f14f11bac81c4281447747d70b37aff2108cc439"
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
