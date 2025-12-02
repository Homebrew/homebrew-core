class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3"
  url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "4516ecfa420826088c187efd42dad249367ca94ea6cdfc24e3030c3cf47af7b4"
  license "BSD-3-Clause"
  revision 37

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fc0af13a24f948ce120e53c3b49164d4dce7925e0453a2147b40d4660b3078b2"
    sha256 cellar: :any, arm64_sequoia: "1ef01f3ef8d54872471c0c53738319addd4cfba25c286e875cdd0fc0ff3e821b"
    sha256 cellar: :any, arm64_sonoma:  "8565a65c53220da5ff7deec3dc3f3f6e74ce6a8754e065a247b8e664278bf8bb"
    sha256 cellar: :any, sonoma:        "719c50d57ab1a5ac1ee1b0799df200a661614cb8915d7b59484f24c7f37f59b6"
    sha256               arm64_linux:   "b4de95c87df10889dab4cda151b186688c546b02bce2b42a69f7fc85ded68d1f"
    sha256               x86_64_linux:  "6df1ee97c6f1fe938fc7ced9a734c4126f7f545c4501efd17df68f124626efd9"
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

  # Backport cluster manager api needed for newer `vineyard`
  patch do
    url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/commit/17d7b60194e5b6d9005bb10947905a393f432624.patch?full_index=1"
    sha256 "b0d1bce10cf2f03124af744f2a184162b6b555b09d162b8633ed8ab9b613f8f8"
  end
  patch do
    url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/commit/3ad17314d6e8c26beb88501f8e74e506ccaf26b8.patch?full_index=1"
    sha256 "52dd6132b03c4c1210bb1c0b8a32ff952f84b198d612903c10a53b7a4f5ce2b9"
  end
  patch do
    url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/commit/ea56cee80f441973a0149b57604e7a7874c61b65.patch?full_index=1"
    sha256 "bce8ef02bc56f2ac430d580191217ff78210cc6e261d29c7031a22e65cd05693"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
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
      cmake_minimum_required(VERSION 4.0)
      set(CMAKE_CXX_STANDARD 17)
      project(test LANGUAGES CXX)
      find_package(protobuf CONFIG REQUIRED)
      find_package(etcd-cpp-api CONFIG REQUIRED)
      add_executable(test_etcd_cpp_apiv3 test.cc)
      target_link_libraries(test_etcd_cpp_apiv3 PRIVATE etcd-cpp-api)
    CMAKE

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
