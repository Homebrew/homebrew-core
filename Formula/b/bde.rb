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
    sha256 cellar: :any,                 arm64_ventura:  "52a26850cf6c809d5ee9a790ecf83cebb05c2902fd9f68bc3792c1c6f932e677"
    sha256 cellar: :any,                 arm64_monterey: "3de3d1bfa894eee380194680a413ec544ae0d565d9e7b982718ac00df6dbee91"
    sha256 cellar: :any,                 arm64_big_sur:  "ecaa49cd4f0fa0897e92c66621beeb880f07766e711971cc328e3597f64628cb"
    sha256 cellar: :any,                 ventura:        "d4a6a0f9e18e6ecbeb74a9a214dc7d16b69025f3cae27ad7833e7bee97266349"
    sha256 cellar: :any,                 monterey:       "1196a6d58418a5fdc28aa1fd7a7237890921d40cb3af2f3133b577f7139dd0e0"
    sha256 cellar: :any,                 big_sur:        "163764a63426d9e1abe047681541d8b2fc83c4d0e84028cbc2bc60f1e550e130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4989b788eb112bd6e997d5824b9d9965b3f9b56d02aa190848c6a39265c7c3bc"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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
      -DPYTHON_EXECUTABLE=#{which("python3.11")}
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
