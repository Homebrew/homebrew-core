class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/refs/tags/4.31.0.0.tar.gz"
  sha256 "07199eb1e99e13b47391111797f4fedbc830f6c2cd60f81dad75f0e677811bd5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03d528a146e8a75b468263dd29c74ce4d7b336a50bfaa68025e322636b5087c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27b46af97aab36048be806d14903f8e88842c64c3c1b6cf19ad6e8d70933e5f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d37dad0d0c0220f2da90dfe2589dbf843f55c2f0b883b226c4661135462a361c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3a0df4f414c93644a510c37cc53a70ca7722b49121f0033d03e6d3324a78805"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20011fa4541d350fc033a1b341efa8e15430182de5aec3dbaf64c454eb7b53b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2538d734ece223495e94d99944d4457b9f9c831075473c60664e460becdff2ab"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/refs/tags/4.29.0.0.tar.gz"
    sha256 "0e9fb2871cf0df9df2d86c240d736e94f47de67de4ccfeacb1f03e4a6a1f3a09"

    livecheck do
      regex(/^v?(\d+\.\d+\.\d+\.\d+)$/i)
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
      -DPYTHON_EXECUTABLE=#{which("python3.14")}
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
