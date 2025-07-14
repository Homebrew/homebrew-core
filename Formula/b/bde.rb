class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/refs/tags/4.27.0.0.tar.gz"
  sha256 "93d8ebde23c5cabe43add6b907195588d1bd614c76d77830a44e16ec13e6413b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49d7f2ac1e8c25a1ca3c1bd0139b800f8390a24681245400e79470d8ff8fa88f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3c5d53110a3ef3d638ebbc308187dcf9da49aea3ac6ad32f63a8315e9e7f056"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e28bd1786a2422c756aa293dd9f39feaa186b91523942a41d523cc93e5120ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "84bbb8ea9424b87afc699af5bea938dd3e1011ae99d9a420c60258cdfe48e510"
    sha256 cellar: :any_skip_relocation, ventura:       "f28d6a9f769f187ba0f7591a386c4546e44a27ffee0406965f2ed44efde53a32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d84aa3d863967385f064e317a10cd666671bc7f371c2a9060b38e17feff067f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4990ecf71141c18b475a0322877de497c7b7a5e868c25d661f1f309d59e3aa0"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/refs/tags/4.27.0.0.tar.gz"
    sha256 "934c5f1599f1c4e05f82e20e610f78532aa37d9868311e7cfc39b789c48fa1b5"

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
