class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3"
  url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "4516ecfa420826088c187efd42dad249367ca94ea6cdfc24e3030c3cf47af7b4"
  license "BSD-3-Clause"
  revision 24

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b75a379c34271e10aa1c66a93e9e43564705bd0f466082c2421eab34d4875ef"
    sha256 cellar: :any,                 arm64_sonoma:  "2cc4b487d922af2975285f95c72f0f0b6f03f78e9c71ebc0d28df29483d93d26"
    sha256 cellar: :any,                 arm64_ventura: "b40c36e27f404b45779295b2dec763549d4f88df8c66e68d1e1ac4754064baf9"
    sha256 cellar: :any,                 sonoma:        "331317ceab9d9715a74e989cb193e3676abd0b643a56384a2e5c26d46f683948"
    sha256 cellar: :any,                 ventura:       "78da8b94ad86f56b17d566fac989dda9bd0921197fada28489fdcf2556e9becc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "293bda3d1d31363ad8e48e82bfe30e843d77922f36fdd381204f7e6026b05205"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "etcd" => :test

  depends_on "abseil"
  depends_on "c-ares"
  depends_on "cpprestsdk"
  depends_on "grpc"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"

  # Fix for removal of GPR_ASSERT macro in grpc.
  # https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/pull/281
  patch do
    url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/commit/ece56adf4d01658a5f0668a3618c97153665581c.patch?full_index=1"
    sha256 "f3686647436045a9a53b05f81fae02d5a5a2025d5ce78a66aca0ade85c1a99c6"
  end

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

    (testpath/"test.cc").write <<~CPP
      #include <iostream>
      #include <etcd/Client.hpp>

      int main() {
        etcd::Client etcd("http://127.0.0.1:#{port}");
        etcd.set("foo", "bar").wait();
        auto response = etcd.get("foo").get();
        std::cout << response.value().as_string() << std::endl;
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      set(CMAKE_CXX_STANDARD 17)
      project(test LANGUAGES CXX)
      find_package(protobuf CONFIG REQUIRED)
      find_package(etcd-cpp-api CONFIG REQUIRED)
      add_executable(test_etcd_cpp_apiv3 test.cc)
      target_link_libraries(test_etcd_cpp_apiv3 PRIVATE etcd-cpp-api)
    CMAKE

    ENV.append_path "CMAKE_PREFIX_PATH", Formula["boost@1.85"].opt_prefix
    ENV.delete "CPATH"

    args = %W[
      -Wno-dev
      -DCMAKE_BUILD_RPATH=#{HOMEBREW_PREFIX}/lib
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"

    # prepare etcd
    etcd_pid = spawn(
      Formula["etcd"].opt_bin/"etcd",
      "--force-new-cluster",
      "--data-dir=#{testpath}",
      "--listen-client-urls=http://127.0.0.1:#{port}",
      "--advertise-client-urls=http://127.0.0.1:#{port}",
    )

    # sleep to let etcd get its wits about it
    sleep 10

    assert_equal("bar\n", shell_output("./build/test_etcd_cpp_apiv3"))
  ensure
    # clean up the etcd process before we leave
    Process.kill("HUP", etcd_pid)
  end
end
