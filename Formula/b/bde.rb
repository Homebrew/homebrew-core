class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/refs/tags/4.29.0.0.tar.gz"
  sha256 "2f6e952092b8ac311afc8c113ead9d673d16a7cb1c76e350504c9785718cb7cb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9c2a99df4f44d9e6dbf3925ea5a869e3db37ef82004cbf556956072b73a0100"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "691f7e0da877b3441e5ea20e8ef576fd52c3aa2660b08ee8f9f72512a11063ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ba3fe5df396f397d17e19fc233f81a50db35b08935435203e5ae53818fed2cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bf0ece129c462567c622599ce4acad3552c69d78f9b609153e0be29f94b97f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc8a114d99998e029a70ce224ff6854d824c76947970eac57923db7b60929cb7"
    sha256 cellar: :any_skip_relocation, ventura:       "c7685008f2ead6437eeb3b14cbaaced6bfab2f9a2a25691661e6d85004da81a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2528eca3e18ebc4b501c07b3eb36442c287fc2d5a3ea0cc5c4a1522527065172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8743eb505a9490252ebcefa014252b3ad2ec1c3756babc525585f9fd007b674f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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
