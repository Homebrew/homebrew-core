class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3"
  url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "6874643b511a01656b4e4bc9805f911630963718f05807cbebc4b1c8bfb0fdc6"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c2ca7f7d6163bd00085cff6c638aaaeeab6d5c989ab5cfc2fc8cd1d5fa265207"
    sha256 cellar: :any,                 arm64_monterey: "52d5d1efe7cea26e46fa2e6c480f975b608fdd286b9553ac1999e9bae9d9a1b5"
    sha256 cellar: :any,                 arm64_big_sur:  "f43bc27d5097934575234a84b2ba06d3d5d7e99a82a20bcb80fdf847ad5ffeba"
    sha256 cellar: :any,                 ventura:        "709fb5e6ec697880224ca2426b44d3886b0fd5fa9aeb1ad2be0c079f5c22f36d"
    sha256 cellar: :any,                 monterey:       "5d6691e57d8e8b1c41c97e4b5bb8b69b39c984e4befb62f6075b78c893ca541e"
    sha256 cellar: :any,                 big_sur:        "077dc3cb57e5caa7ab246f36f47dcec2104e952d10622708d0bcf393f4cfbf66"
    sha256 cellar: :any,                 catalina:       "674d32fd9d883ebef3d1b13710cf68982c7c5b7c8d7a6eeb3fcb34e34e989e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46c11b600e4eba310d11d07b5ca101b08bfab8bae3f70749ea280e41810c4c18"
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
