class FalcosecurityLibs < Formula
  desc "Core libraries for Falco and Sysdig"
  homepage "https://falcosecurity.github.io/libs/"
  url "https://github.com/falcosecurity/libs/archive/refs/tags/0.24.0.tar.gz"
  sha256 "33db1708932affc977c86344dcdbdca3497f92a52dcb86be840aa8c1bda1b10f"
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
    sha256 cellar: :any,                 arm64_tahoe:   "9b0f9ae7d0000beff11588db2f85bbb088eec9779a2ebf62a16baf428e4d1373"
    sha256 cellar: :any,                 arm64_sequoia: "ebc5eeddc5785471d34efaf8951656aac8cb767b874a39b0a9122f49ac6c1fde"
    sha256 cellar: :any,                 arm64_sonoma:  "4262a5fc488d49c51c0e66eac6fbd21da064a10fba76ba74ef69d004ed590c5e"
    sha256 cellar: :any,                 sonoma:        "ebd161566b7695341a652828d935a1840fd0be396d242d8585ac32252df55982"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "689e27d1e9b10913d2a958458fdc452e59c8352622123e2eb29ee690e09afdf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89c7fe5a84d52efc04a77ffdbdd218ddfcfd978b1ab8574ce17a3c95927d871d"
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
