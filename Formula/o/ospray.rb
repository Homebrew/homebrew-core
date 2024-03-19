class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "0b9d7df900fe0474b12e5a2641bb9c3f5a1561217b2789834ebf994a15288a82"
  license "Apache-2.0"
  head "https://github.com/ospray/ospray.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4e6b528ff98519227a2c29a3ef9d3ccd101ab54cf90cb9dd3e191b0fded2f5cc"
    sha256 cellar: :any,                 arm64_ventura:  "4d73f569d4d84fd0b49d3bc518837441cdaf395a6d88c2967f86c7fcdbe38c0c"
    sha256 cellar: :any,                 arm64_monterey: "fc9f7cf3c1d9ddf7993ade253ab98de07603cfbb1eeedd264354d28bbb3df3f0"
    sha256 cellar: :any,                 sonoma:         "c70571c9a32a24f68128fd62039f0e1510889b137c8ad9fe334a64dbb3f76c54"
    sha256 cellar: :any,                 ventura:        "aba734d9bbf8edb7079814520ba8cff1959048a0aa2d2bec4e1d955fe88b2911"
    sha256 cellar: :any,                 monterey:       "82f9d9de8cc78e6db8b14216a8f9203ef559a9655bca7595abc21bbe6f436c66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ede52a6c1a8662804500b9569e72c0b2ad8fcac56462ee82a87ff8965c60e8a3"
  end

  depends_on "cmake" => :build
  depends_on "embree"
  depends_on "ispc"
  depends_on "tbb"

  resource "rkcommon" do
    url "https://github.com/ospray/rkcommon/archive/refs/tags/v1.13.0.tar.gz"
    sha256 "8ae9f911420085ceeca36e1f16d1316a77befbf6bf6de2a186d65440ac66ff1f"
  end

  resource "openvkl" do
    url "https://github.com/openvkl/openvkl/archive/refs/tags/v2.0.1.tar.gz"
    sha256 "0c7faa9582a93e93767afdb15a6c9c9ba154af7ee83a6b553705797be5f8af62"
  end

  def install
    resources.each do |r|
      r.stage do
        args = %W[
          -DCMAKE_INSTALL_NAME_DIR=#{lib}
          -DBUILD_EXAMPLES=OFF
        ]
        system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
      end
    end

    args = %W[
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DOSPRAY_ENABLE_APPS=OFF
      -DOSPRAY_ENABLE_TESTING=OFF
      -DOSPRAY_ENABLE_TUTORIALS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <ospray/ospray.h>
      int main(int argc, const char **argv) {
        OSPError error = ospInit(&argc, argv);
        assert(error == OSP_NO_ERROR);
        ospShutdown();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lospray"
    system "./a.out"
  end
end
