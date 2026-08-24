class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/refs/tags/4.39.0.0.tar.gz"
  sha256 "032ecb934810137bb889d036c0bf038dc7e70a01bf72b6ea39b72d0b1583c6b3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c334c1fffe29a3094ab97c99710f7e3f464bd0065a4126d0223aa370690f6012"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32c19f0f204da5d6e9c3b5fcf58b692c9709fd39c17a862995cb2bd913eb3e31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a1786cc049dcd2d8618856ecacdb9ee0e28c56591fd7822fd64a9c5a7a513c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c74972577e88987a5df9be49c00c8f0d993dcf629f1ff8d63793d84b995ce9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45c0fc3e78953e80d680ae2b7d5972a959d733a77870cdb32ce4dfb6a5ccbc2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c26b17b9a0cb3d1d47e6157daaf3cb829c90538b05e595cfd4754c48567d3531"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "pcre2"

  uses_from_macos "python" => :build

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/refs/tags/4.39.0.0.tar.gz"
    sha256 "e0917609ac4315387ea4f24e96e97f89a438bb7909ae1c12952f7d7b242ee197"

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
      -DPython3_EXECUTABLE=#{which("python3")}
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_CXX_FLAGS=-fsized-deallocation
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
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++17", "-I#{include}", "-L#{lib}", "-lbsl"
    system "./test"
  end
end
