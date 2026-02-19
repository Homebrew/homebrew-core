class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/refs/tags/4.35.0.0.tar.gz"
  sha256 "4d02a2e1c5bc0f15e98829468dd544dbfbab99d863ce5b85285150ded1112feb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6555d9b453146d3610abb9c7cbfd3a2ad88e6a58d264b419e16932a431d5df9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aca33c38a41568ab4c9f8916983da74b70b120f10662a0b1e2abf1fedf14727"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d09ba1b55f8d778fea20e37e03bc4d9fbad3c0bf68efc55daba6e93ad747ff4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f30a5d7988154dd971078b0d29c59513d890e73aa264340a58c1b5e73393a009"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cffaeaef2a3631c861fbf179ad6b8ce0b425062d46a05d0dc46d38789c161751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7749fc5d445967a2bfd305aa8ccb7e16e01986ba47d4d465f974c671ebf8a4c6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/refs/tags/4.35.0.0.tar.gz"
    sha256 "6022d8e7b96e78804581dcc9741001a8f33c65d69d3914cb1efbc647df9d0908"

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
