class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3"
  url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "7f334e9a219a65cfcefd7a526d8d9ab613f77d75879f82645c9dc47f17b0e8c8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "06e274c6f09ad79e788560c16ea301345ccd10df23f2813b97b5af6a8d3a0db0"
    sha256 cellar: :any,                 arm64_monterey: "7fa39bc8e4bbd8203b6c7db1079e808c17013e97eb218603806be3bc8150ec0f"
    sha256 cellar: :any,                 arm64_big_sur:  "f82dd933843197331f2ff9349c357eb3b33921a116c24dc26680e6523d8b7c67"
    sha256 cellar: :any,                 ventura:        "82f92f44a3b98eb23755525cacf80fd2251623b604f8a9796718f3c320b9196d"
    sha256 cellar: :any,                 monterey:       "4f085d5904add94641f896e6daf3bcdd58d87b8f7c14ce375d0baeb96bffd54b"
    sha256 cellar: :any,                 big_sur:        "70395dac20dacef8f8c4a205a0316315aec94f68b4a6818578e1730ccb64d20b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c6c607195af0f8adf9dc08157f4278738cedc590db7e63a476d5412c12fc715"
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
