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
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4925bb362b14157eb0750a6d5c69d8b09a1a102760a9d36e9b59e093ce07e2d6"
    sha256 cellar: :any,                 arm64_sequoia: "2ab0d6417bac8f9b12aeedcfb055f369fffffed0add628e472e356102c9b24a6"
    sha256 cellar: :any,                 arm64_sonoma:  "aeecb5be6dce400386271a9dc631724c80ea82baaffc248e25c6d2669cf5020f"
    sha256 cellar: :any,                 sonoma:        "c9681e7dbf9e916d319a11f772d34042c120b9ac8150714ddf79c875f330f8ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11390b6046ad8354663b45ee30f9a892f418e5e34ae5b0757259ffa84e382289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a48407bee28bf27da13bef17b80fa5961bcc1dac74969c57bb97d1fe2d9487ec"
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
