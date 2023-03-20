class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/3.112.0.0.tar.gz"
  sha256 "e6dfade0a1d9a1b9554b8a94e359169dab492162ffa956cb889817033daf5405"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "95a5affd84fe492b0cffcd4eacae5135384bd43c22734a548a8d09efb9c9f3bc"
    sha256 cellar: :any,                 arm64_monterey: "eeaaf4793e96719f25a4886fd6e7af6b9cbe425771f2d8de8e6a6409bf70df84"
    sha256 cellar: :any,                 arm64_big_sur:  "2ea70b99f5f12f7923908a955437c81b490956e094417dda7110acbbe9f4bbda"
    sha256 cellar: :any,                 ventura:        "ee465031a946e91f985f71e40d9083b7926ee97fb59d07f91d9e7a20e06907b8"
    sha256 cellar: :any,                 monterey:       "5a97b17eb3ae97f812e6f150d50198e495d8c3a29a56fba4fea38b694a07900c"
    sha256 cellar: :any,                 big_sur:        "516457fc0ee244818d00973fc1862b9a261d1c7a80f8ca81b35b08e582939d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8964001110baab7e5f9333e8fb5c99f60e84d97a9517363e95fd75bfaeca273"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/3.112.0.0.tar.gz"
    sha256 "4588c478f995f65fbd805cbe102f4440b602504d2cbd4937b79b3e49b06da0f4"
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
