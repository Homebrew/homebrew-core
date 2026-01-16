class Cppcms < Formula
  include Language::Python::Shebang

  desc "Free High Performance Web Development Framework"
  homepage "http://cppcms.com/wikipp/en/page/main"
  url "https://github.com/artyom-beilis/cppcms/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "4a7a2217b3fa59384650912a7000e016c308b4fa986a3d2562002691e5a9d6e7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5900ff545cb23a62aeee87f0298f708dea78f5276f18a26f26ca25af67dc32f7"
    sha256 cellar: :any,                 arm64_sequoia: "e0c6465ebda4259d556b40968bd23dc813d9767f67726a65c2830c3c3ba2e232"
    sha256 cellar: :any,                 arm64_sonoma:  "81bab19d59c5e6892944778302cbb0e78d04a8c36b20aecf02e59d9c7b655d78"
    sha256 cellar: :any,                 sonoma:        "72d3733bbf759cb8886a96b97046c50f48ec5589ff14c1fb2b17316dd789a1cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26ff565057fd36a3c9f7f834764447a9442789580dd13c3a0689a0df31610f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a43f290fed874f7b5e88c3727f084ffb4332662a5534abc8b610a2c11b9b9d81"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "python"
  uses_from_macos "zlib"

  # Backport support for CMake 4
  patch do
    url "https://github.com/artyom-beilis/cppcms/commit/92164714273bddfc032d930d3d89f78428110939.patch?full_index=1"
    sha256 "7934a74f9b39d2108944895f826d960ee34d4b88f52f2482a683f15d395fd74a"
  end

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "bin/cppcms_tmpl_cc"

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=11",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DDISABLE_PCRE=ON",
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
