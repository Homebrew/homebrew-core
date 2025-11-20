class Cppcms < Formula
  include Language::Python::Shebang

  desc "Free High Performance Web Development Framework"
  homepage "http://cppcms.com/wikipp/en/page/main"
  url "https://downloads.sourceforge.net/project/cppcms/cppcms/1.2.1/cppcms-1.2.1.tar.bz2"
  sha256 "10fec7710409c949a229b9019ea065e25ff5687103037551b6f05716bf6cac52"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/cppcms[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "c67928d45ecdf779f5cbde1a74527f1f474063e8038fc6103222f6066c058ff8"
    sha256 cellar: :any,                 arm64_sequoia: "b274decb22153c7de85e5fa491fe54493186b6b6258de506695aa6e725a3a1b5"
    sha256 cellar: :any,                 arm64_sonoma:  "c81184c372aced3829c5dc2df3c748b19afe1522ca7b25195559ed4de6777ba0"
    sha256 cellar: :any,                 sonoma:        "5afdc34fc8074dc1589f9d84f34fd7db0374c83fe57ddf69b8898898b8d524f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a621276dcd5bf2942c3cbf70f4ccb2033603598b9cd0b69a04302f93a173c274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf5e4745de3da3bc5794c0d8d36e434288d41627aca22209d837bf526dc81b9e"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "python@3.14"

  uses_from_macos "zlib"

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

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
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

    sleep 5 # grace time for server start
    begin
      assert_match "Hello World", shell_output("curl http://127.0.0.1:#{port}/hello")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
