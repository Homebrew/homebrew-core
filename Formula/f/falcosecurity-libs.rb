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
    sha256 cellar: :any,                 arm64_sequoia: "4a6ffe7949b2b99681b5910fa8e446474fb9da0f77bb456f4648a36326859d0d"
    sha256 cellar: :any,                 arm64_sonoma:  "7a03e319abca76c699350e6cd29ecc4a64034783529dd4f5f174816015665604"
    sha256 cellar: :any,                 arm64_ventura: "34039bf2d3496a572bf2ac212b3f9cc38345a0e80e56e8d793bc5968debff22b"
    sha256 cellar: :any,                 sonoma:        "83488cbd04dfd36f495d901d219ad43d14b0acdd92dd72796a442229054c4586"
    sha256 cellar: :any,                 ventura:       "3b3d9451afb904eb09553ea09f17d8f23959dd5aa0deeaa0f84219f9c7b8d637"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e813a5f7afbf2097931699e748fff735474d5ab0ab5ca70822fba459188dedb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a691bd6a78782032b328fb7a70d3c16b743c58a644602f020a5c0c60eec65361"
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
