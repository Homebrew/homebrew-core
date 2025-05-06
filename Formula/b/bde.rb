class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/refs/tags/4.24.0.0.tar.gz"
  sha256 "52eee2f753108d5dbea6f05b11a08dc3ae90923379208705a7e5f686bf2c7faa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3e591173e29d21043c0e93209d39e9b0c832d2577e01afab0b11a0cb5fb4abc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b3e442804969707bd0c7a9491865e8c5f97664d33e6312a29a0b98c5cad56ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5908a2ccc520b05a5a1315fd2ad8b9738503d63c96fcaf31ff864cc10a313355"
    sha256 cellar: :any_skip_relocation, sonoma:        "84fb57fa5d81941643b84942907cf383aef5582a11f8d4f1976172cadaf5ddd1"
    sha256 cellar: :any_skip_relocation, ventura:       "fccdadf682135e3b8cb3901d4f9c4edb8f777cd67eb131dffb84782fdb9e04cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc98fb664f4467eca2cce4b12591d155a12ecc62ecea73f224ec57ace5ef444a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8b2767daf6e305140a0e66d87ddac865187937ff57929fe640764e2d6ab79b3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/refs/tags/4.24.0.0.tar.gz"
    sha256 "0907c0019a90a7cd0000f92c093ab0de5c7750ea749766701555bbb47521472f"

    livecheck do
      formula :parent
    end
  end

  def install
    (buildpath/"bde-tools").install resource("bde-tools")

    # Use brewed pcre2 instead of bundled sources
    rm_r buildpath/"thirdparty/pcre2"
    inreplace "thirdparty/CMakeLists.txt", "add_subdirectory(pcre2)\n", ""
    inreplace "groups/bdl/group/bdl.dep", "pcre2", "libpcre2-posix"
    inreplace "groups/bdl/bdlpcre/bdlpcre_regex.h", "#include <pcre2/pcre2.h>", "#include <pcre2.h>"

    toolchain_file = "bde-tools/cmake/toolchains/#{OS.kernel_name.downcase}/default.cmake"
    args = %W[
      -DBUILD_BITNESS=64
      -DUFID=opt_exc_mt_64_shr
      -DCMAKE_MODULE_PATH=./bde-tools/cmake
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_TOOLCHAIN_FILE=#{toolchain_file}
      -DPYTHON_EXECUTABLE=#{which("python3.13")}
      -DBdeBuildSystem_DIR=#{buildpath}/bde-tools/BdeBuildSystem/
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # bde tests are incredibly performance intensive
    # test below does a simple sanity check for linking against bsl.
    (testpath/"test.cpp").write <<~CPP
      #include <bsl_string.h>
      #include <bslma_default.h>
      int main() {
        using namespace BloombergLP;
        bsl::string string(bslma::Default::globalAllocator());
        return 0;
      }
    CPP
    system ENV.cxx, "-I#{include}", "test.cpp", "-L#{lib}", "-lbsl", "-o", "test"
    system "./test"
  end
end
