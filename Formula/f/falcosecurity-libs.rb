class FalcosecurityLibs < Formula
  desc "Core libraries for Falco and Sysdig"
  homepage "https://falcosecurity.github.io/libs/"
  url "https://github.com/falcosecurity/libs/archive/refs/tags/0.25.0.tar.gz"
  sha256 "237e22ff2aeb9eb48d04badcf7b77d4fdf9703b5873cc81d48c124254fcbd6e3"
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
    sha256 cellar: :any,                 arm64_tahoe:   "a6c4f76d6a1fb6cea007f51222df8624204af1cd1ef8583dc45ef26587120b55"
    sha256 cellar: :any,                 arm64_sequoia: "0f01587df5cbd3554856a14f4da553810f2bfe3b992a949d5ce78f0566d15630"
    sha256 cellar: :any,                 arm64_sonoma:  "c792905a55f6bda678020bfb4c726d05b50bc0ec4ecec7053da74440e74e62bc"
    sha256 cellar: :any,                 sonoma:        "57260e164506b872e6976ee8a141bad2ce93c95aa0171a1eea0446f1ebe7a745"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21b7515ab5dfc2af0fe016a21117a0adab57f784e06f42f03edde974821c59bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8e24d6157e74165bbbd9bc822f39a1bfedf470949862f3e791eab07bcbd9b72"
  end

  depends_on "cmake" => :build
  depends_on "valijson" => :build
  depends_on "googletest" => :test
  depends_on "jsoncpp"
  depends_on "re2"
  depends_on "tbb"
  depends_on "uthash" => :no_linkage # headers needed for libscap/uthash_ext.h

  on_linux do
    depends_on "elfutils"
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
