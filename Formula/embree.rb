class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v4.0.0.tar.gz"
  sha256 "bb967241f9516712a9f8e399ed7f756d7baeec3c85c223c0005ede8b95c9fa61"
  license "Apache-2.0"
  head "https://github.com/embree/embree.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "43fe52a4fb0d099033029ab02cba993c43cb78181f82a3cd7214c9b92845d930"
    sha256 cellar: :any,                 arm64_monterey: "07d0bbc91a36c907bd3e90a51cc7b89624eca1e4f49c4a551eafb892829593dc"
    sha256 cellar: :any,                 arm64_big_sur:  "cf1adbab65ab590cdff0566a55ea8bb5031a6ca1142def1aa11f9ba4daee5865"
    sha256 cellar: :any,                 ventura:        "5774c3f27b897ab12df9af5e2081c71a282cd64d811da2fdd902baa90c4920a7"
    sha256 cellar: :any,                 monterey:       "cd3a8dad89525a5b48c07e3bf9ed2e1bdbeb192ad3a99bbce332cd714338e7e3"
    sha256 cellar: :any,                 big_sur:        "a845948e82834d987cef6c2b52ca9bcf75ac6a1e60396be8d9bf728fad37a4a3"
    sha256 cellar: :any,                 catalina:       "715da9c241e420ecf61b6d7c68153623c847d9d8ceace2cb4dfc86e848c67365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae18d81783de71e6cb7f1ca0d058b8ec26a6f9a076364726c18369ea35a6ddd5"
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "tbb"

  def install
    args = std_cmake_args + %w[
      -DBUILD_TESTING=OFF
      -DEMBREE_IGNORE_CMAKE_CXX_FLAGS=OFF
      -DEMBREE_ISPC_SUPPORT=ON
      -DEMBREE_TUTORIALS=OFF
    ]
    args << "-DEMBREE_MAX_ISA=#{MacOS.version.requires_sse42? ? "SSE4.2" : "SSE2"}" if Hardware::CPU.intel?

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end

    # Remove bin/models directory and the resultant empty bin directory since
    # tutorials are not enabled.
    rm_rf bin
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <embree4/rtcore.h>
      int main() {
        RTCDevice device = rtcNewDevice("verbose=1");
        assert(device != 0);
        rtcReleaseDevice(device);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lembree4"
    system "./a.out"
  end
end
