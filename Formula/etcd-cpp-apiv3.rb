class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3"
  url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/archive/refs/tags/v0.2.11.tar.gz"
  sha256 "e245bcc1cb92fac615c226800ab3ca0872deaa89ee9ec969fb6150b0923e2f7e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d82f11609d735e42824bfc19655513bff4d9151e45e965aa2bf608cdfbdbd4e5"
    sha256 cellar: :any,                 arm64_monterey: "d4fa9f0247d1e0ce00b286b099429b7997dd6066d0a09e80a93466ee3b6f3693"
    sha256 cellar: :any,                 arm64_big_sur:  "bd05059dbfdb17caf0d8a1018ccc348bc521204fa3706a2e3c2a4833a8abfefc"
    sha256 cellar: :any,                 ventura:        "123eede944d49086d4984a5e4e568996b53581569943351908419e0e7e9d5358"
    sha256 cellar: :any,                 monterey:       "a967264677e8551cacfbf40804ef5458d9b2c31286f4f2be2ba6a420db0d2c93"
    sha256 cellar: :any,                 big_sur:        "0c9e8cc8dbbd5571259123551d840a1eb5115941e2931bf9105713ceda7e42aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9299ab9da7cf89aaca7c72ab143a79fa187494e818cb5e2141e542f39dc5bb84"
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
      if OS.mac? && Hardware::CPU.arm?
        # etcd isn't officially supported on arm64
        # https://github.com/etcd-io/etcd/issues/10318
        # https://github.com/etcd-io/etcd/issues/10677
        ENV["ETCD_UNSUPPORTED_ARCH"]="arm64"
      end

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
