class FalcosecurityLibs < Formula
  desc "Core libraries for Falco and Sysdig"
  homepage "https://falcosecurity.github.io/libs/"
  url "https://github.com/falcosecurity/libs/archive/refs/tags/0.22.2.tar.gz"
  sha256 "53cfb7062cac80623dec7496394739aabdfee8a774942f94be0990d81e3b2fbc"
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
    sha256 cellar: :any,                 arm64_tahoe:   "acd724bb7f64d985b8d232e17417af090231c0c82ce7d0eb685193dac340062c"
    sha256 cellar: :any,                 arm64_sequoia: "860f44f28f71a111c16b859d772a81db6eb03ef36c478ecc4b55bdb629b7a472"
    sha256 cellar: :any,                 arm64_sonoma:  "e892518e61bc53ae1649eb5ee6cf463e3ac84fd6f4fb4ae44c937898f988c454"
    sha256 cellar: :any,                 sonoma:        "3c1374bc7fd7b7ff338cd3d00aa1e85d08e6bcea4efea3b1950ec1ace8aff64d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0861cf4e0463d24c5799a8d9b8425d6b3ebd2c3ce67196a15083451fc85155b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a7d399f5223e726dfca95955ef5f86cdecd07a98da8e20a2866f05f9bd6ae30"
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
