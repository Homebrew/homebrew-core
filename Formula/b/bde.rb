class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/refs/tags/4.37.0.0.tar.gz"
  sha256 "28dfdf953f3a6864bd7b1fc97cda7ab47ef6949e4c052a1f4adcfa469a4f5021"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d6e784c41640c6b2a9b7dcb7e85a8bbd7eeb0d74487e9cad69e2a21cdd66fc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9778317d4b9df7e2b3699a1dc4b50152b442f02ced6d67bfb3318429ecee2b14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a560426b57a1bc9e15f2806d42e74d2ac6e888636e3c3f339623ce1813d64ebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7fe416abe94bfd7865070a37a67b90e5bcec3964209a80d871b08b7872bc942"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46e95e8bc700169456c93be25f402124c65949623f4a97c346d42663c4fc6ad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1be1b7a8eced7a65442ba03a670d2ec47bd8bf8366f8c56b159b385e85b6eeca"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/refs/tags/4.37.0.0.tar.gz"
    sha256 "37c0ad6fef5a7f4374005cf7a5310b05380b638b7cec62f4179b6545798ac5f7"

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

    args = %W[
      -DBdeBuildSystem_DIR=#{buildpath}/bde-tools/BdeBuildSystem/
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPython3_EXECUTABLE=#{which("python3.14")}
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
