class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/refs/tags/4.25.0.0.tar.gz"
  sha256 "18a39abd2de974307d6e789667787ef154dd56a6d53ccf673921ceb92d398168"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e581f3e85626020521c682eea6f8d10017c0091240363308ba4a1b6c7716a74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ef1ce38761968e7bc3e31451b795abec4a30c37dc196b5602f0c0a57ad1c7b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e7efb202670063093de55caef74194296feb761c353ef5ac63672f30252a980"
    sha256 cellar: :any_skip_relocation, sonoma:        "63a49cb2ba935f83c2ffc4eeb983bd8a510182a7fa3820e24873654c22ffd85f"
    sha256 cellar: :any_skip_relocation, ventura:       "09f3836e853c7e1bcb2fc42ebd0e03d28c037fd33fe4d58bd590d9aebc139848"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "056654a53d7dc4cf2989f184eed5094ed0140ed5357a7a192e58c08877d96ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d25264d6bfd91fb594af2dfd70965256fb8834cddff5380d363ffe0064ade338"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/refs/tags/4.25.0.0.tar.gz"
    sha256 "2e565d40b16696ffd81614e1fb356138d1f49645e3b7960bb69e631007d152b4"

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
