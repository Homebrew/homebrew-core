class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/refs/tags/4.8.0.0.tar.gz"
  sha256 "5dfad6bf701acba16b4ffb1da58d81dc26743288117b0b50ce4d7214603d909a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5795f3e1c52cb98aeec7c2678f060f2e94500fb1a9dd8b68c31dbc347ec05c9e"
    sha256 cellar: :any,                 arm64_ventura:  "9056bcaab5bd65600019316eb42b502c30e614455faff16c0db65732389b662c"
    sha256 cellar: :any,                 arm64_monterey: "e0fadd564b1f8dc72f43faee5705e968c3a803b9ba71b7e2a1903c8e73100fa5"
    sha256 cellar: :any,                 sonoma:         "5d2ff14421850452e4d56031188763267f8005ff4a57fd31fcf27e6340dff60d"
    sha256 cellar: :any,                 ventura:        "547a50de15385779bdd50fb09603b563fe1c541ba1ed8d15c305ff30db0da45b"
    sha256 cellar: :any,                 monterey:       "df1954fe0914a593566be37c8f6bdfb69b68826bb3cad44f1352a856332ce904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb2a6523e5adccbfb81cd1bf5594a6c023167a13887b8d1f5f25a5330d5bc228"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/refs/tags/4.8.0.0.tar.gz"
    sha256 "49fdfb3a3e2c4803ba8a9bfa680cb50943c41ef1e6b1725087b877557b82bd35"
  end

  def install
    odie "bde-tools resource needs to be updated" if version != resource("bde-tools").version

    (buildpath/"bde-tools").install resource("bde-tools")

    # Use brewed pcre2 instead of bundled sources
    inreplace "project.cmake", "${listDir}/thirdparty/pcre2\n", ""
    inreplace "groups/bdl/group/bdl.dep", "pcre2", "libpcre2-posix"
    inreplace "groups/bdl/bdlpcre/bdlpcre_regex.h", "#include <pcre2/pcre2.h>", "#include <pcre2.h>"

    toolchain_file = "bde-tools/cmake/toolchains/#{OS.kernel_name.downcase}/default.cmake"
    args = std_cmake_args + %W[
      -DBUILD_BITNESS=64
      -DUFID=opt_exc_mt_64_shr
      -DCMAKE_MODULE_PATH=./bde-tools/cmake
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_TOOLCHAIN_FILE=#{toolchain_file}
      -DPYTHON_EXECUTABLE=#{which("python3.12")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # CMake install step does not conform to FHS
    lib.install Dir[bin/"so/64/*"]
    lib.install lib/"opt_exc_mt_shr/cmake"
  end

  test do
    # bde tests are incredibly performance intensive
    # test below does a simple sanity check for linking against bsl.
    (testpath/"test.cpp").write <<~EOS
      #include <bsl_string.h>
      #include <bslma_default.h>
      int main() {
        using namespace BloombergLP;
        bsl::string string(bslma::Default::globalAllocator());
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "test.cpp", "-L#{lib}", "-lbsl", "-o", "test"
    system "./test"
  end
end
