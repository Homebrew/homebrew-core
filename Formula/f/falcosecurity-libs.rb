class FalcosecurityLibs < Formula
  desc "Core libraries for Falco and Sysdig"
  homepage "https://falcosecurity.github.io/libs/"
  url "https://github.com/falcosecurity/libs/archive/refs/tags/0.23.1.tar.gz"
  sha256 "38c580626b072ed24518e8285a629923c8c4c6d6794b91b3b93474db7fd85cf7"
  license all_of: [
    "Apache-2.0",
    { any_of: ["GPL-2.0-only", "MIT"] }, # driver/
    { "GPL-2.0-only" => { with: "Linux-syscall-note" } }, # userspace/libscap/compat/
  ]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "31f62d0a6b6cdc47caec9b91fa4344eccf60778c5b6fc681f266cc80d302ed46"
    sha256 cellar: :any,                 arm64_sequoia: "75f2505e66679c29ddd5d171739d99f2eff81739c760fe951db0021f6bed04db"
    sha256 cellar: :any,                 arm64_sonoma:  "c3c2795a01629343ea81a28c6f0502037efd78a96c95a7e213814329ed4aaded"
    sha256 cellar: :any,                 sonoma:        "8bfbd2ec9a25200b49ee9605009b3c18c9ced86c8414139b04d71c8702ef73d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f873cefe2aadfb5ab5d30b3af09749ce904d23f177d88d3d12a1c9b54f06b860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c609f76a4680fa60080ae7360f80a69b0ec4d62317cebf66edadffd76e674fc6"
  end

  depends_on "cmake" => :build
  depends_on "valijson" => :build
  depends_on "googletest" => :test
  depends_on "jsoncpp"
  depends_on "re2"
  depends_on "tbb"
  depends_on "uthash" # headers needed for libscap/uthash_ext.h

  on_linux do
    depends_on "abseil"
    depends_on "curl"
    depends_on "elfutils"
    depends_on "grpc"
    depends_on "protobuf"
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -DBUILD_DRIVER=OFF
      -DBUILD_LIBSCAP_GVISOR=OFF
      -DBUILD_LIBSCAP_EXAMPLES=OFF
      -DBUILD_LIBSINSP_EXAMPLES=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCREATE_TEST_TARGETS=OFF
      -DFALCOSECURITY_LIBS_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test/libscap/test_suites/userspace/scap_event.cpp"
  end

  test do
    system ENV.cxx, "-std=c++17", pkgshare/"scap_event.cpp", "-o", "test",
                    "-I#{include}/falcosecurity",
                    "-L#{Formula["googletest"].lib}", "-L#{lib}",
                    "-lgtest", "-lgtest_main", "-lsinsp", "-lscap_event_schema"
    system "./test"
  end
end
