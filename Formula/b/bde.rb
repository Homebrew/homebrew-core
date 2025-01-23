class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/refs/tags/4.18.0.0.tar.gz"
  sha256 "87426d6837a1261e385e755361e961c5d75ec35fb1a227a9763a6388de4129fc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "18c5f09e30f7f505fed326240086dc6845882f54bc438d4bcd6eb0da855b4f0a"
    sha256 cellar: :any,                 arm64_sonoma:  "eab1e15ad41fc1e6a5786cebca8b344a2765ff05e8c1bf2cb786dcaef287df95"
    sha256 cellar: :any,                 arm64_ventura: "d2c3615e8fc71ae75abe5ef5ba866044f2b60a12e27b01a54f0e69451e32e76b"
    sha256 cellar: :any,                 sonoma:        "4e78518f55df6ef43f24161615bee765951ae64ce0b47d6c2d4d8d51d64529ed"
    sha256 cellar: :any,                 ventura:       "05a07a35eb98203bc715687c2d03b6edc573295460c2bfbbc7e6228c121017f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d1d4dcd8a06831ed13ef9f8a70510db7e90e591d4f18929a925787edda28e02"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/refs/tags/4.13.0.0.tar.gz"
    sha256 "d70ab85eb1a4325f3d569a6b7ea0f0a44a6143fd91905ab5fbaa5e1fed111a68"
  end

  def install
    (buildpath/"bde-tools").install resource("bde-tools")

    # Use brewed pcre2 instead of bundled sources
    rm_r buildpath/"thirdparty/pcre2"
    inreplace "project.cmake", "${listDir}/thirdparty/pcre2\n", ""
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
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # CMake install step does not conform to FHS
    lib.install Dir[bin/"so/64/*"]
    lib.install lib/"opt_exc_mt_shr/cmake"
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
