class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/refs/tags/4.32.0.0.tar.gz"
  sha256 "af38579feec6a7fed16f851887cfafdf66badfc8e0ad0396ac0cbd41d5b46d12"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d606a0769d591a048bff3e3bc642b99db07c2423d9cb58adf08107198b49956d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc0f907130b6e8a057a402b5e1b22ad28945b183e5c577b3424c3a572c542167"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e02ace1d98e309b65092fafe6d3fbcb0b34ea00375c4d2e44cbe69d58618b28"
    sha256 cellar: :any_skip_relocation, sonoma:        "be9d782ccdacc4ae59d17253866614c042284e9b2231122714a6811c9fe1665c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "323c16d64113bd5be437d0a826cedd11e1d8dd01fa34bda728eae8c3f59ba0e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b840e4ca14416c97b75988803f51ce118189f9df2c311ca0e7999deb90a57f06"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/refs/tags/4.32.0.0.tar.gz"
    sha256 "eb5d482b9b37e14944b1240f7ebeb635a218fedc9154b185b129a333df4893e2"

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
