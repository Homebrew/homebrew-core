class FalcosecurityLibs < Formula
  desc "Core libraries for Falco and Sysdig"
  homepage "https://falcosecurity.github.io/libs/"
  url "https://github.com/falcosecurity/libs/archive/refs/tags/0.23.2.tar.gz"
  sha256 "928128add70724938ee8dcc57ef3653aec162f7d575975a559b04b238a3b448c"
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
    sha256 cellar: :any,                 arm64_tahoe:   "eb5cc011b7195aadd56652db0b5b9b0c9565e3c6c7ded777614a0cbbe5d0a838"
    sha256 cellar: :any,                 arm64_sequoia: "31e1103260059e8ff540b8b036a935b628d44b848d2ca0a27d76bf889dee7301"
    sha256 cellar: :any,                 arm64_sonoma:  "85747d25e4f1fac02d6ee4c92b64f98eecc28771d2d3b7d51779eb8bcae9461e"
    sha256 cellar: :any,                 sonoma:        "8a527fe71fde2cafb2d77b7cb60a505a8eedbbfa18f0443ba1855a9289c7b9f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7df3b6d580d0e7fc042b7f27502e5984a8057a20f03aa4daa6b91fbcb483d790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80ef8c42783b34856544f79eec28c142fe54fe5f74a90279ee760f1e644f199f"
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
