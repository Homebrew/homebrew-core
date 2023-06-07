class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3"
  # TODO: Check if we can use unversioned `grpc` and `protobuf` at version bump
  url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "5faf1ca697f9889c269a2a0cb2237d8121959f72bf6eca4f61dffdcb9c6d9d46"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "72f6a58af9bbba15c9c386cfcfc39420a632a6d6b7d554c33fe7b6906edfa4d2"
    sha256 cellar: :any,                 arm64_monterey: "5782a8b3685b84fd52e9f4aba54e8f089fd6b69c368035d8498c01cfaaac9cf2"
    sha256 cellar: :any,                 arm64_big_sur:  "f3708d358a76f4cdf3671b6245a929d2643cc1d057e8308a054ec645c5ff2999"
    sha256 cellar: :any,                 ventura:        "4f46dc2ed85f3edeffd69b56d091ba6164315bff89c969cc71ffbf1b45f9ebab"
    sha256 cellar: :any,                 monterey:       "2fe00b8bedfd2717b6d8801a37a164f86ed2e501f64dcc9e70579876ddeb9d5d"
    sha256 cellar: :any,                 big_sur:        "d7deaacbe3e66017739e94e33c093bba386d72051726475e7d44a6120286debf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7bbe7c8f1aee56a8a73a65aeef4a4d181f7fa8051fae1cb879714d05ef7e872"
  end

  depends_on "cmake" => :build
  depends_on "etcd" => :test

  depends_on "boost"
  depends_on "cpprestsdk"
  depends_on "grpc@1.54"
  depends_on "openssl@1.1"
  depends_on "protobuf@21"

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
                    "-I#{Formula["grpc@1.54"].include}",
                    "-I#{Formula["openssl@1.1"].include}",
                    "-I#{Formula["protobuf@21"].include}",
                    "-I#{include}",
                    "-L#{Formula["boost"].lib}",
                    "-L#{Formula["cpprestsdk"].lib}",
                    "-L#{Formula["grpc@1.54"].lib}",
                    "-L#{Formula["openssl@1.1"].lib}",
                    "-L#{Formula["protobuf@21"].lib}",
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
