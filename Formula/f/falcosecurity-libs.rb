class FalcosecurityLibs < Formula
  desc "Core libraries for Falco and Sysdig"
  homepage "https://falcosecurity.github.io/libs/"
  url "https://github.com/falcosecurity/libs/archive/refs/tags/0.25.4.tar.gz"
  sha256 "272a5a0c05e7c10a658ed9649023e6179061a4ab29e012602893586ac64b5938"
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
    sha256 cellar: :any, arm64_tahoe:   "c2fb9fce6c52339aecd0188eeba179ce9b892687facbd4e8ceb26d00afe21672"
    sha256 cellar: :any, arm64_sequoia: "666d3a149e4236d5a030634d0d4c3b868a1e1c0651e945a0ff5d2426876e038d"
    sha256 cellar: :any, arm64_sonoma:  "07c8c8fc98294c63bd51935fc20e460556305d14c2b94ffca49cae90db07db00"
    sha256 cellar: :any, sonoma:        "c3afe8a1760123bd7a34857399f282bff14e497c3350fa1138c6f2df73d529d8"
    sha256 cellar: :any, arm64_linux:   "a68fe882d7876b866ed31b9bb5f9b78e2b2fa2b4fdc5461935166e7c4de88e52"
    sha256 cellar: :any, x86_64_linux:  "194c569e1d36ec07246cc6353eccad3ba3813e02c52faeab5e0b59d0c705aa5f"
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
