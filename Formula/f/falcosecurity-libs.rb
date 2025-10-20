class FalcosecurityLibs < Formula
  desc "Core libraries for Falco and Sysdig"
  homepage "https://falcosecurity.github.io/libs/"
  url "https://github.com/falcosecurity/libs/archive/refs/tags/0.22.0.tar.gz"
  sha256 "1a46032e8eadbc5c4d29b767178cc3d2e04810cbf13ba2057854661aa74abbe6"
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
    sha256 cellar: :any, arm64_tahoe:   "9bfc3a5565d4a0c1627ba1676e046b026a4749bd18a9fa6515ea6f86bb0ada18"
    sha256 cellar: :any, arm64_sequoia: "1e0d96744115216127c699c225d79a14546fd02442446eccaefcce9c26a00ffa"
    sha256 cellar: :any, arm64_sonoma:  "e83c14251093de7f787f90b16dd05a43bb63602c8fe798b33527f33afcd2ffb4"
    sha256 cellar: :any, sonoma:        "3a7d832058dab19503fdd3a6ff5406e01ec5d2180bea500b07714ad9e3acd186"
    sha256               arm64_linux:   "387dcc11dbe47674028e1ea51df07c552e05e0a8d1ceedafc815aa16faaea330"
    sha256               x86_64_linux:  "58eceafbf96bda5eabc0b82652be7ae7004ea7b893e02f6ab115fe1409bfbfac"
  end

  depends_on "cmake" => :build
  depends_on "valijson" => :build
  depends_on "googletest" => :test
  depends_on "jsoncpp"
  depends_on "re2"
  depends_on "tbb"
  depends_on "uthash" # headers needed for libscap/uthash_ext.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "abseil"
    depends_on "curl"
    depends_on "elfutils"
    depends_on "grpc"
    depends_on "protobuf"
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
