class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/3.124.0.0.tar.gz"
  sha256 "f33ff2b4cf8eec1619866b35f9655e464d3414dbd1e9c979358f6fab259c4137"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "2ec67f02b6f24193a57ef4da58e6f14e93cfe472889e0c31647bb014baf386a3"
    sha256 cellar: :any,                 arm64_ventura:  "a77966d44eff4c5151c256e3797067412d63009763ff533352b6afa4ec3db868"
    sha256 cellar: :any,                 arm64_monterey: "c47b0514a2dbd1692a347066c3dd9880c370af0adb8f858af88d62e6438d3c91"
    sha256 cellar: :any,                 sonoma:         "70d427ee0ea6ede4beb5f37826bab1949e55d5141f4bb7971bc0748c20d74417"
    sha256 cellar: :any,                 ventura:        "2a30bc3f66bf879b34bb29cee2d1b909e52b46d51cd0c6407dbe8cd49ba69673"
    sha256 cellar: :any,                 monterey:       "808d18c89ae1f51c77d718ddf1b91be6dfc47856f6eba4e533174a865f2b16fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26b96ecc32f3c86336cb592434a4d68486264a73a1fdb7b4b09be21916498a4f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/3.124.0.0.tar.gz"
    sha256 "f38b95a174e27a3f82cd8b30421dd0036ca7f39bd89cd3413d0c2d78756dd29c"
  end

  def install
    (buildpath/"bde-tools").install resource("bde-tools")

    # Use brewed pcre2 instead of bundled sources
    inreplace "project.cmake", "${listDir}/thirdparty/pcre2\n", ""
    inreplace "groups/bdl/group/bdl.dep", "pcre2", "libpcre2-posix"
    inreplace "groups/bdl/bdlpcre/bdlpcre_regex.h", "#include <pcre2/pcre2.h>", "#include <pcre2.h>"

    toolchain_file = "bde-tools/cmake/toolchains/#{OS.kernel_name.downcase}/default.cmake"
    args = std_cmake_args + %W[
      -DBUILD_BITNESS=64
      -DUFID=opt_exc_mt_64_shr
      -DCMAKE_MODULE_PATH=./bde-tools/cmake
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_TOOLCHAIN_FILE=#{toolchain_file}
      -DPYTHON_EXECUTABLE=#{which("python3.12")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # CMake install step does not conform to FHS
    lib.install Dir[bin/"so/64/*"]
    lib.install lib/"opt_exc_mt_shr/cmake"
  end

  test do
    assert_equal version, resource("bde-tools").version, "`bde-tools` resource needs updating!"

    # bde tests are incredibly performance intensive
    # test below does a simple sanity check for linking against bsl.
    (testpath/"test.cpp").write <<~EOS
      #include <bsl_string.h>
      #include <bslma_default.h>
      int main() {
        using namespace BloombergLP;
        bsl::string string(bslma::Default::globalAllocator());
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "test.cpp", "-L#{lib}", "-lbsl", "-o", "test"
    system "./test"
  end
end
