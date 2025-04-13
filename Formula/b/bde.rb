class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/refs/tags/4.23.0.0.tar.gz"
  sha256 "0c591fb87f6fe1e829eacd86f5608b439941eafd88916a42b073bd44f79ffddc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0caa9bea81b44980ec2922e9843f053298844ee20ef44d8188aa65655de36a2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa317fcf963dcd936fd81046569e1ce9c12b9a064f02cdfb1f50b2ffae4582a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90f00ab12c6685d10e5f8597c3c79a02178cbf6fddc458ff6d37d85c8be15e72"
    sha256 cellar: :any_skip_relocation, sonoma:        "09566a76f25448536754475718f2583d7803af0dade8f43d923576e9d9ac8718"
    sha256 cellar: :any_skip_relocation, ventura:       "99d2b72b816f3e835f35c013c6f27bc19c9d254a8bbd352f7de0cb7fc2cb248f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b86d5b3990ba4fff341eb81f42770d69747bbb921992f0c13deaef5a3315b226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9f3f923b67a50cf8326c41ebbc52c8f2e24076242796435586db72aa8ad0501"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/refs/tags/4.23.0.0.tar.gz"
    sha256 "997fbe16756948449df06e8bf66b9cc289cb03f318a01489f58245f0bdaa2e4c"

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
