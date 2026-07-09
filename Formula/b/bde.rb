class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/refs/tags/4.38.0.0.tar.gz"
  sha256 "0a8eba6db1a643208f91d3c806bd51a3e7bf6f77ad7c58c200097d4dd961d323"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8ea458c832d920bcc5d133444a79f2978bac85987d5c2ac0718ace35809f764"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "613c5844b10b4cacedaa326de2f2d83d1837c9c7ba0eca8a7a72aa33df6a2aa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dc4cfd381bf0e2aadcaec37b3e827908ea446560759accb2d40ac7171beaeb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9be8f92465a3dbf5a75a5adb2507356cdd88f8e563a0c8c35781343fb6240b10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2350054462474b340ffe39f4aa83180bba4240212dfc1d63c70af5d6b944b977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dab17fed9239bb826d0991923520d87936b8e759d924e29566da19e1784853bd"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "pcre2"

  uses_from_macos "python" => :build

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/refs/tags/4.38.0.0.tar.gz"
    sha256 "7796f2db05ef009f4ee7c036c4c5861bc12a45dc39f5b9539bd53794f6a1e783"

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
