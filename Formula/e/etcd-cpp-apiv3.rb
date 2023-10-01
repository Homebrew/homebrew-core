class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3"
  url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "1a6f4ed634f3c75cbfaa2768917e280c6df77cac2af5d945ad67ef20d53d8b60"
  license "BSD-3-Clause"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b4e512e915caf04f7b9f509a0da401118d735afc69b6644705c7773a15b4bc5a"
    sha256 cellar: :any,                 arm64_ventura:  "0967350e5aefc6fadef0a31ff439b4daad02bd2b161a9e0f5af16c1e83bfe8ba"
    sha256 cellar: :any,                 arm64_monterey: "77b88abc3f01e265089598410465fd814c5cca9578fc2fdd5d6c25441e9249e2"
    sha256 cellar: :any,                 arm64_big_sur:  "c0fdf8e7eb00a48ef69ef794c07ea6146838449b8838c12a7314c4a92a996b82"
    sha256 cellar: :any,                 sonoma:         "5e9e7d5db902517a149e1ad88d37d6a6f34da08c7f9185e06924e8bffcbc2bcc"
    sha256 cellar: :any,                 ventura:        "1acef2ed84ca1250646313f6196aff1a9610db2a0c5030e544882668595cbafe"
    sha256 cellar: :any,                 monterey:       "06d0624167c07f6b7ed1d026d501bd41979468ed4cb4d7c9c0f162bc8c7da0f3"
    sha256 cellar: :any,                 big_sur:        "9b8a88edd420954d60ef1682dcc06e4f713d0cd31179033ebb9155911f4b3aef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adf69daf9faed652615651f80d76a9d4cb3fab149ba95043781fd0cf6c47fd5f"
  end

  depends_on "cmake" => :build
  depends_on "etcd" => :test

  depends_on "boost"
  depends_on "cpprestsdk"
  depends_on "grpc"
  depends_on "openssl@3"
  depends_on "protobuf"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DBUILD_ETCD_TESTS=OFF",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    port = free_port

    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <etcd/Client.hpp>

      int main() {
        etcd::Client etcd("http://127.0.0.1:#{port}");
        etcd.set("foo", "bar").wait();
        auto response = etcd.get("foo").get();
        std::cout << response.value().as_string() << std::endl;
      }
    EOS

    system ENV.cxx, "test.cc", "-std=c++17",
                    "-I#{Formula["boost"].include}",
                    "-I#{Formula["cpprestsdk"].include}",
                    "-I#{Formula["grpc"].include}",
                    "-I#{Formula["openssl@3"].include}",
                    "-I#{Formula["protobuf"].include}",
                    "-I#{include}",
                    "-L#{Formula["boost"].lib}",
                    "-L#{Formula["cpprestsdk"].lib}",
                    "-L#{Formula["grpc"].lib}",
                    "-L#{Formula["openssl@3"].lib}",
                    "-L#{Formula["protobuf"].lib}",
                    "-L#{lib}",
                    "-lboost_random-mt",
                    "-lboost_chrono-mt",
                    "-lboost_thread-mt",
                    "-lboost_system-mt",
                    "-lboost_filesystem-mt",
                    "-lcpprest",
                    "-letcd-cpp-api",
                    "-lgpr", "-lgrpc", "-lgrpc++",
                    "-lssl", "-lcrypto",
                    "-lprotobuf",
                    "-o", "test_etcd_cpp_apiv3"

    # prepare etcd
    etcd_pid = fork do
      exec "#{Formula["etcd"].opt_prefix}/bin/etcd",
        "--force-new-cluster",
        "--data-dir=#{testpath}",
        "--listen-client-urls=http://127.0.0.1:#{port}",
        "--advertise-client-urls=http://127.0.0.1:#{port}"
    end

    # sleep to let etcd get its wits about it
    sleep 10

    assert_equal("bar\n", shell_output("./test_etcd_cpp_apiv3"))
  ensure
    # clean up the etcd process before we leave
    Process.kill("HUP", etcd_pid)
  end
end
