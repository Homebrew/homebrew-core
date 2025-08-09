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
  revision 5

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "298c3db3d6d9411553add4e48cd7efc2eebc5d7ceda8b6794d4ffc5e5df92e83"
    sha256 cellar: :any,                 arm64_sonoma:  "ec5da5700f58b6f36dc90b70483a4aeb8a0b0b340cda2342cace20753f56004f"
    sha256 cellar: :any,                 arm64_ventura: "1765718b724f2072b2255e2798e331594b748641968682445be30e160b68f960"
    sha256 cellar: :any,                 sonoma:        "2e9c31b952a3a15f7a729cbcc139be4357dce3b6970956fbbdb59269fa0023db"
    sha256 cellar: :any,                 ventura:       "4a6cb14afa2a6eb0cca5f574725e83f9e065ea44b52e14881a5293e1eeede3cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d547d920437ea99fdd376c56859b5fa68e5cabe21e1eefc0cf1b09b1f120a178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7642126ee5941974e1278a0dc4866f924c3adcfb011d59a13e4bcd75e7260ca"
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
