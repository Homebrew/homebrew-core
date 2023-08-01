class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v4.2.0.tar.gz"
  sha256 "b0479ce688045d17aa63ce6223c84b1cdb5edbf00d7eda71c06b7e64e21f53a0"
  license "Apache-2.0"
  head "https://github.com/embree/embree.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2261fe69114ce6a0956c40606781a566063486c28f9f5a2553c6cdbd96d69f33"
    sha256 cellar: :any,                 arm64_monterey: "44dbb124c76006ca031901d771cc3ef486f5b9a5a28c9c184f188f24977483ec"
    sha256 cellar: :any,                 arm64_big_sur:  "b3272667d14223536df68132129e28b4fa6eadc1e8d1029f3c690f1687200548"
    sha256 cellar: :any,                 ventura:        "d71a66af2cf6fbad76a0d23d87d74608daa146d00b119e469ab97a168c3006f0"
    sha256 cellar: :any,                 monterey:       "ebcc7f2a4b73e3aeffd23aa0dd9d161de07fcf449272e42ab1268e4d14fbb713"
    sha256 cellar: :any,                 big_sur:        "e2e1ea492dbaf6710a82953d792a8b5f7721cbb74faf07e014aea9a234a89606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e2c4848faffce311d57a3e2b2423ed3221c3a5b145f02881fa795c63171fd38"
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
