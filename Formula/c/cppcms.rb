class Cppcms < Formula
  include Language::Python::Shebang

  desc "Free High Performance Web Development Framework"
  homepage "http://cppcms.com/wikipp/en/page/main"
  url "https://github.com/artyom-beilis/cppcms/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "4a7a2217b3fa59384650912a7000e016c308b4fa986a3d2562002691e5a9d6e7"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "78fd3c8d81ce0b0feb720b7da8db1ebfdf00670dd7d4c133bfe22a2cfa2049a1"
    sha256 cellar: :any,                 arm64_sequoia: "1ca0e2347ea05bdd0d8d91e38d2e5e48e0452ec14ff25751ae2665c36859b491"
    sha256 cellar: :any,                 arm64_sonoma:  "5407fbfe3aaccbc61545b918f41d98529d51e5666de00146d4e73e01cd68cb2e"
    sha256 cellar: :any,                 sonoma:        "509c45a58217091401a6afc4ab929fe65f6ece4e2db7268f0252842016cf1998"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c93be15dcdb0cbf3ae83438c373f8fb407545a6622de1827d5fa4da934eac5b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "086440ca1c958fb8a70d99ab91e81b56809e836f831b6959a0d24eac7a92d66b"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
