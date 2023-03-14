class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3"
  url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "1157a9431f270bd09776ae5b7cabf3b9b6a8281b1c415585d78104daa1e213e0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8d9f0f556d2ad51618441e8af53070823dadd3568b24ba27a34bb7548ddbbbec"
    sha256 cellar: :any,                 arm64_monterey: "2a80e6622547f62070b98ba10332413cab53a87e382689b88ea0f1acb974ef6d"
    sha256 cellar: :any,                 arm64_big_sur:  "9f2496cb8e6c41ad19370980479346840a27ef147f493bdcc001e4a3c9ff91e5"
    sha256 cellar: :any,                 ventura:        "86df3d5f238c1e16c189e1da57a7d559e4072be3046bc7898590f6bb0c896884"
    sha256 cellar: :any,                 monterey:       "24dab9d379fbeed4307854665f5f70c1d3e89024ffd61d46f6fb563e2922d815"
    sha256 cellar: :any,                 big_sur:        "ae0ae6ac2bc63f7358b7a1b3390be9af368b7df9aa0cb4f6dbdc6e8eebb685b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61dcbafc1fd9e34c84603c3a41443de07771873ba2471941d47e6e7025d1a5dd"
  end

  depends_on "cmake" => :build
  depends_on "etcd" => :test

  depends_on "boost"
  depends_on "cpprestsdk"
  depends_on "grpc"
  depends_on "openssl@1.1"
  depends_on "protobuf"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DBUILD_ETCD_TESTS=OFF",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
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
                    "-I#{Formula["openssl@1.1"].include}",
                    "-I#{Formula["protobuf"].include}",
                    "-I#{include}",
                    "-L#{Formula["boost"].lib}",
                    "-L#{Formula["cpprestsdk"].lib}",
                    "-L#{Formula["grpc"].lib}",
                    "-L#{Formula["openssl@1.1"].lib}",
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
