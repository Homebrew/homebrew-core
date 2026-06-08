class FalcosecurityLibs < Formula
  desc "Core libraries for Falco and Sysdig"
  homepage "https://falcosecurity.github.io/libs/"
  url "https://github.com/falcosecurity/libs/archive/refs/tags/0.25.2.tar.gz"
  sha256 "136327d148154f91f73ff81366bd707a2930e72bbd2e491d68ba7ee62afaffa0"
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
    sha256 cellar: :any,                 arm64_tahoe:   "7a5a151013b1dca20761ea0088aab98ee4158eedd4afa3e52e47cd3ace1f4d68"
    sha256 cellar: :any,                 arm64_sequoia: "f9b280c14d897f3fd5c559f2a06cc0cac31054748b050d9729732ec332fb330e"
    sha256 cellar: :any,                 arm64_sonoma:  "cf428a479d6e39ac1f1025c72d912845d42a10973528d000380441c01e396e31"
    sha256 cellar: :any,                 sonoma:        "2cd94d575f66b408586202c3295ae18b26d8d013fa8d6010174654695f8b1920"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daf2dceb283c0470f0c03d2bd480084b59dd98c1b3e14c25791b2e7bdca2d4dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "144f2e81e88ff8f3a3cf89b22d17b89c9f04f70540f331a203c2066dc528b7c1"
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
