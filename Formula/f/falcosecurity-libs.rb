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
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "062c84b1c1b9aefd37fc21a24a080696de7628179db68afb476434ec6d1259ad"
    sha256 cellar: :any,                 arm64_sequoia: "3157dac9f7e18da3c9d69d9063093aa2a24b0da4157c7f6feff07f62e499d90b"
    sha256 cellar: :any,                 arm64_sonoma:  "fa3501fae74c5571d561f7ee505075e0d639b3ae9b08fa98efe8680623803a5e"
    sha256 cellar: :any,                 sonoma:        "e55f9c47e82612287daa5dd9f612a5be0333855d61faf015f0e714e490644a0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e31261a2bc605021245f8dfb524b43ca55ab45c24fe9f7e20e14fd80ae8b565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e82d7a193ab2fb5e4af7a9e378769696e4e5a9012d09c652e0ec0f194dc71a81"
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
