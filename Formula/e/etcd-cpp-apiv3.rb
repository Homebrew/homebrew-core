class EtcdCppApiv3 < Formula
  desc "C++ implementation for etcd's v3 client API, i.e., ETCDCTL_API=3"
  homepage "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3"
  url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "4516ecfa420826088c187efd42dad249367ca94ea6cdfc24e3030c3cf47af7b4"
  license "BSD-3-Clause"
  revision 52

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6a669495ddf923d98ece017e30af22705f5917f7669d7e5a856c2442fc4cf90e"
    sha256 cellar: :any, arm64_sequoia: "d2ae183d7b0b7f4bf5cfc2de059310b1b92a5fa0f0ab0e0201b59ad3f8a61934"
    sha256 cellar: :any, arm64_sonoma:  "247175f64a084933a9dcd5a58feee17fb228f90ad5583a0e4b77f9791dcf0e7f"
    sha256 cellar: :any, sonoma:        "77772e5837a9831ec64bc57640043c15793c4d3aa3bbdbfbda8ec79cfc9b3389"
    sha256               arm64_linux:   "8f600cbe4e9063ba95483238cf5dda61c82a972311cf839c2672056d28ca7bbe"
    sha256               x86_64_linux:  "e0f9e1af852e7233976555c385933c2348961dc632a2b887d7d54968e8056b40"
  end

  deprecate! date: "2026-06-12", because: "needs deprecated cpprestsdk"
  disable! date: "2027-06-12", because: "needs deprecated cpprestsdk"

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
    type :backport
    resolves "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/pull/281"
  end

  # Backport cluster manager api needed for newer `vineyard`
  patch do
    url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/commit/17d7b60194e5b6d9005bb10947905a393f432624.patch?full_index=1"
    sha256 "b0d1bce10cf2f03124af744f2a184162b6b555b09d162b8633ed8ab9b613f8f8"
    type :backport
    resolves "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/pull/270"
  end
  patch do
    url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/commit/3ad17314d6e8c26beb88501f8e74e506ccaf26b8.patch?full_index=1"
    sha256 "52dd6132b03c4c1210bb1c0b8a32ff952f84b198d612903c10a53b7a4f5ce2b9"
    type :backport
    resolves "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/pull/276"
  end
  patch do
    url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/commit/ea56cee80f441973a0149b57604e7a7874c61b65.patch?full_index=1"
    sha256 "bce8ef02bc56f2ac430d580191217ff78210cc6e261d29c7031a22e65cd05693"
    type :backport
    resolves "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/pull/277"
  end

  # Backport GCC 13 build fix
  patch do
    url "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/commit/7c6e714f188f9576e25e0350cac4181139eec23e.patch?full_index=1"
    sha256 "96c9e4cbadb46c9ebfc6f4f386125161b68df4c12f7c85feffda39dff41a7277"
    type :backport
    resolves "https://github.com/etcd-cpp-apiv3/etcd-cpp-apiv3/pull/299"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    "-DBUILD_ETCD_TESTS=OFF",
                    "-DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@3")}",
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
      formula_opt_bin("etcd")/"etcd",
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
