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
    sha256 cellar: :any,                 arm64_tahoe:   "27b747d3d3084ac979f783188fa9e26341f278181196f48dace42bb72bb72399"
    sha256 cellar: :any,                 arm64_sequoia: "276bc934131bae13ebca0401a490e5ab6688e9f5e51b129ee61a096a0468b3ed"
    sha256 cellar: :any,                 arm64_sonoma:  "773301a5bf953dc35076d8ef5b2fccf9a439827ce3ff266f4d1941bb55570fab"
    sha256 cellar: :any,                 sonoma:        "6e14e2e1c9085c510659349eacfab620b147f64a99f538d98425c487abb89aea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a08a7a0cbf1962a41ba265dffc4d647f84e8f70932b3be709d8d67d8c2b88122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d95433c52e96ee4ee8548237e427e9a6e581f95c6f80aaa128dc54876ed3ad7"
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
