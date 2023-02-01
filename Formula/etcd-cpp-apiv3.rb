class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3"
  url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/archive/refs/tags/v0.2.12.tar.gz"
  sha256 "84f969c663cdb7bf7b4bf9954446b7d585f89ae8f47655c175159b1dcabbfb07"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "322c766949dfaf4ef3948a5bec97de4c28e067fa2fa126b6f5aeba57afddd761"
    sha256 cellar: :any,                 arm64_monterey: "1e52e351a76e1a9e32db8ecfacda64d326b95bec34f4b992cb35a0ac010f37de"
    sha256 cellar: :any,                 arm64_big_sur:  "ea8d17e359c8ac01fffaae93a47b7fdee148cf4b227a7781bcf13f0a95a0d5d4"
    sha256 cellar: :any,                 ventura:        "b58753c040de6ebc68494b395af3d43453ddd293a81954a534f16013053c4e3d"
    sha256 cellar: :any,                 monterey:       "fed3b127bd216520fed3c5af854db1d5bacba71248bb12302cfb090e08d0ce60"
    sha256 cellar: :any,                 big_sur:        "9f6608405804e46ccf588162d57560346cde8a3f99074a241991d74173346259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d0024dc709eac327427c6ad4b77f6bd6894231fe9f01d363778d4138ac68e4c"
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
