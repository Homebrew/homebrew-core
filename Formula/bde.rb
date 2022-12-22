class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/3.61.0.0.tar.gz"
  sha256 "46dcdcf06f3cf582170848721dd6d8ca9c993f9cfa34445103d3cee34a5d6dda"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "256b6b2dc9d8f90aeff41a81033423328e30b3562ee97ccb2eb67d794d589804"
    sha256 cellar: :any,                 arm64_monterey: "ed70c99ed0b09d134629d5cbf2c7bf080d157d484e36f5f24ac5f743eb72a2c2"
    sha256 cellar: :any,                 arm64_big_sur:  "dd66675152e9ae3aec33fda26947e88ffcf14253e3231c6c17500845aacaf4b8"
    sha256 cellar: :any,                 ventura:        "591390887f0db7b229d9602cc9d4e2a88c408763305bfbb9cab9e6145466582d"
    sha256 cellar: :any,                 monterey:       "7e1368d3386c5d1916ba6d6f54f8f55010b8406cf3f33af40ddc5c00f2163f58"
    sha256 cellar: :any,                 big_sur:        "a2af33666b2a068b703029f7184e5c222235f1f6647baad480f4e84241e459de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e05b551ddab098cc86920de7336414b873494bdcf41367bc30e0c63122bf036"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/3.61.0.0.tar.gz"
    sha256 "7d66eb149c7e59021467c386ba5c6149a8923e836c6a61b815651b3cac019a7d"
  end

  # Backport support for Apple Silicon. Remove in the next release
  patch do
    on_arm do
      url "https://github.com/bloomberg/bde/commit/39a52e09c83eec761874be2260b692b715117fae.patch?full_index=1"
      sha256 "d3721d8a297687ddd2003386845aaa6ec3f8664ab81551b1ef581fe65ad1cb96"
    end
  end

  def install
    buildpath.install resource("bde-tools")

    # Use brewed pcre2 instead of bundled sources
    inreplace "project.cmake", "${listDir}/thirdparty/pcre2\n", ""
    inreplace "groups/bdl/group/bdl.dep", "pcre2", "libpcre2-posix"
    inreplace "groups/bdl/bdlpcre/bdlpcre_regex.h", "#include <pcre2/pcre2.h>", "#include <pcre2.h>"

    toolchain_file = "cmake/toolchains/#{OS.kernel_name.downcase}/default.cmake"
    args = std_cmake_args + %W[
      -DBUILD_BITNESS=64
      -DUFID=opt_exc_mt_64_shr
      -DCMAKE_MODULE_PATH=cmake
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
