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
    sha256 cellar: :any,                 arm64_tahoe:   "87b28cc5019aba19e2cd7b5b50b98783d69f9daecedeb1c18dfd4c4fdb0ece00"
    sha256 cellar: :any,                 arm64_sequoia: "e1d02fe0c79dade2fe4e5a70fa34152e3587c1a7db8aa656d2b1881060c4e359"
    sha256 cellar: :any,                 arm64_sonoma:  "b801e47686bad7ad3a92b3f8975d014f3ad47b97d96404ea6ffeb53c3df8de9c"
    sha256 cellar: :any,                 sonoma:        "4781af095101df212b5a1009a7f9074d7a506280544bc683468e8c3ece527d27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a14802ce171bcd5d26cbae15d1097f1e25ea581824e50df5fabd50b1a62e39d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c7e23ec4937aa35b066762437b7c9a2e9d7435be1034b2cc8f6e6db40c4b7bf"
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
