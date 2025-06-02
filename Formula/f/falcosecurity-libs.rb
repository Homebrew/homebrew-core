class FalcosecurityLibs < Formula
  desc "Core libraries for Falco and Sysdig"
  homepage "https://falcosecurity.github.io/libs/"
  url "https://github.com/falcosecurity/libs/archive/refs/tags/0.20.0.tar.gz"
  sha256 "4ae6ddb42a1012bacd88c63abdaa7bd27ca0143c4721338a22c45597e63bc99d"
  license all_of: [
    "Apache-2.0",
    { any_of: ["GPL-2.0-only", "MIT"] }, # driver/
    { "GPL-2.0-only" => { with: "Linux-syscall-note" } }, # userspace/libscap/compat/
  ]
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "12242b5955f63f5bb1d63da1e7d6aff53dcd8e46c7ee1d45f0f5c97188b52bd9"
    sha256 cellar: :any,                 arm64_sonoma:  "5f0b5bbeace6d97d2d4d530efb6ceb31bb832254ba53da7603ff49cbd3cec29c"
    sha256 cellar: :any,                 arm64_ventura: "35901d50ffb0081af5a0691a7bf48f88493ddb91009247e20cab075975b3b3bc"
    sha256 cellar: :any,                 sonoma:        "9430e05e710fb2f4ca5e05650c97dc1fe9801d041955e99fb3700f8424156214"
    sha256 cellar: :any,                 ventura:       "2d28344e368790fb18c019b4ad5f36652e4682631d965d868e56139d689fc191"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6b485446614d05f9e36290b4ea161f414497c84b6791fd48825526b3f346c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4e4c9e0bce8685f4c154ffa0a4e926b0717558d155bf43f367618bef8eb1e95"
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
    # TODO: remove on next release which has dropped option
    # https://github.com/falcosecurity/libs/commit/d45d53a1e0e397658d23b216c3c1716a68481554
    args << "-DMINIMAL_BUILD=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test/libscap/test_suites/userspace/scap_event.cpp"
  end

  test do
    system ENV.cxx, "-std=c++17", pkgshare/"scap_event.cpp", "-o", "test",
                    "-I#{include}/falcosecurity",
                    "-L#{Formula["googletest"].lib}", "-L#{lib}",
                    "-lgtest", "-lgtest_main", "-lsinsp"
    system "./test"
  end
end
