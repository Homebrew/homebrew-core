class FalcosecurityLibs < Formula
  desc "Core libraries for Falco and Sysdig"
  homepage "https://falcosecurity.github.io/libs/"
  url "https://github.com/falcosecurity/libs/archive/refs/tags/0.26.0.tar.gz"
  sha256 "430b90236a345f913387adb4c042e7d9140b4fec128f7ef863b7e53f2fdd5e35"
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
    sha256 cellar: :any, arm64_golden_gate: "922d408a33447e4c3a6b51a6cd59969e1ae2e5779975685239269ff541399484"
    sha256 cellar: :any, arm64_tahoe:       "5d2d5c7501403438edec87aec5c30f5fd1de64cf0be7b52f6f2572f7d88ec651"
    sha256 cellar: :any, arm64_sequoia:     "31f3f8d42d7f4297cf0a2eec9545d94875d58a695ddd2a7bde50ac1ad180a1b8"
    sha256 cellar: :any, arm64_linux:       "5aa9f8aefce14c14c367bf704eb8e5151dfe33adc01f143cb4b3b30fcafd87a7"
    sha256 cellar: :any, x86_64_linux:      "42a48f95ca822d8711c2fa126c17fad5c4a3b47e29310a9fad1b5ae8b78dc092"
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
