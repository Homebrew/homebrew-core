class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "2c8108df2950bc5d1bc2a62f74629233dbe4f36e3f6a8ea032907d4a3fdc6750"
  license "Apache-2.0"
  head "https://github.com/ospray/ospray.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "53dc5d5d174208c9983057f7adb43813e67acbc4aefb4d65d363c13b89998113"
    sha256 cellar: :any,                 arm64_sonoma:   "970fe14d8a918196943fd2ff352432fe55d02c2ffb903a97637c0cd8a7d13ac2"
    sha256 cellar: :any,                 arm64_ventura:  "0d1c6ded545f4cb342648e3a604468d476b37bf749dfc19a3eae74b76804bf63"
    sha256 cellar: :any,                 arm64_monterey: "34df9ae68fdd19cdb8cb85074678fd4ed0f259e3ef0f1e9582d015d5d520a7d6"
    sha256 cellar: :any,                 sonoma:         "a72ff4404280c926f33548561b8252863557e9305eeab39c99c102371bf56b5f"
    sha256 cellar: :any,                 ventura:        "a073623de4aaa0e7d97d579b83b882ed03cf9f7030fac1c928862bc2346daa14"
    sha256 cellar: :any,                 monterey:       "e0260bfe736f2dcca20e488902e28b41a4322535e928cafa888f11b3d19db7e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67b279accdeb1e6af969ca0e6bcf7eafb6f56bca61d12aac02f8808f722e024a"
  end

  depends_on "cmake" => :build
  depends_on "embree"
  depends_on "ispc"
  depends_on "tbb"

  resource "rkcommon" do
    url "https://github.com/ospray/rkcommon/archive/refs/tags/v1.14.0.tar.gz"
    sha256 "5aef75afc8d4fccf9e70df4cbdf29a1b28b39ee51b5588b94b83a14c6a166d83"
  end

  resource "openvkl" do
    url "https://github.com/openvkl/openvkl/archive/refs/tags/v2.0.1.tar.gz"
    sha256 "0c7faa9582a93e93767afdb15a6c9c9ba154af7ee83a6b553705797be5f8af62"
  end

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      ENV.remove "HOMEBREW_LIBRARY_PATHS",
                 Formula["ispc"].deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }.opt_lib
    end

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
