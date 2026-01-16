class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/refs/tags/4.34.0.0.tar.gz"
  sha256 "dd16a272c56a0cecce1574adca307d2ea370c95bc076730d89cd32f577704286"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71f25b98683dd1bdd1ee6bb9647c8bd855371f9cf791532e75578642145ef838"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f756419bd6f238c93eb9c3bc4d6f6270009240b03345e633c13613d4d8a24ace"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62a0c88bb8c19285bc3049ccf5ab0f063420a86f8aa0afdeeaf50b80cc9c00e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "782b69336382423e2b0413983980d41c66e6c80b47919e3579100a7e43d6cb73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9d4944a7587e69c9d1e7ca36d00b264414b825431bbe4736529dc24a1f5b4fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1770edc03a970b802307c2c5dea094146473df22d30f0b771f700cf298ad195f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/refs/tags/4.33.0.0.tar.gz"
    sha256 "3b8538d7e3e02e849abda6ff79ca7807a1726f303acc2d4d5e50639d5ddf842b"

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
