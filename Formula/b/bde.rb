class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/refs/tags/4.36.0.0.tar.gz"
  sha256 "70b5f5a28a8084c5ef551a478a27d165192813b4af77b3c1ed66234b6bc673d1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca9c771cf655b9eb228a5697d58033f1ffbdb1a6ba9700792182658dd18fdcd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "506a1ca18af9b72ce73aa3b53d64d22c68f6b4041ceb8df163e08e13e5c47708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edecd76f30383c2bb91bab3b252d182068dfe083d67cf73fd8fc4daff0bd2219"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a3f3680c9e40707e2d09bd2b4f2766874ef6720570c9220d31efd05c980135f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "307ddc4826c42486b6c7784d3b623e0ed5d55abded02d243aee14c43ffa631e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "929c4e3fea86df27636afa9c09fa872f897322ba3c673abb31ae7f77e807c400"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/refs/tags/4.36.0.0.tar.gz"
    sha256 "3467289d98034e874db39040b39ca4c110c275a926b939577b2f18e1ad7d3615"

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
