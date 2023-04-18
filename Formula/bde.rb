class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/3.115.1.0.tar.gz"
  sha256 "78bcd7fcf13275a0f1daa591570edc89623c9f657bfed28c4a8984c546d50ae3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "16948c2acf982cbbf07d062fb4941b6d1413d5ded594659c0133178f09690854"
    sha256 cellar: :any,                 arm64_monterey: "c811a2adb4b933a0741cea88620974765d577b83c4c75b2a38675433bab9c7ae"
    sha256 cellar: :any,                 arm64_big_sur:  "9fefc22f0be588b8251c8a74b37d295f1c9c9ebbfc72ca899400e3a1c0a82722"
    sha256 cellar: :any,                 ventura:        "6c837418c2261cfa4f55c38de9c72dafa5bc9bdfc698aeb80573aee681ca2eea"
    sha256 cellar: :any,                 monterey:       "2f09c5247bb75176dbf950ded0722fd1a83998584611549b917139be56dc0603"
    sha256 cellar: :any,                 big_sur:        "7332fc28fa5dc55528fb0702eed9492fb636f306d86cd9a230aa712744879253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b78fbdf5bfa3cdbdd2206dc52cc75e64c0d583aac073b1af93a213c59063467"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/3.115.1.0.tar.gz"
    sha256 "ccde62feb22615aa6d090cf072de9908f354b75c4cb304a60cafe3e825bc53c2"
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
