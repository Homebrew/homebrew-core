class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/refs/tags/15.4.0.tar.gz"
  sha256 "b16c78e7604b9be9f546ee35ad8b6db6f39bbbbfb19e8d038b6fe2ea5bba4ff4"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8f68fc42dc59b27e10719ad0e7f31db2dfb0d99ce978fbd6fc269e3a73f47364"
    sha256 cellar: :any,                 arm64_sonoma:  "5b2251ec02401af96b5bd227c76d0e84e72fd75d0ba7102ca8cdfa48339863c1"
    sha256 cellar: :any,                 arm64_ventura: "75ae8371498091fc7437550e3b91c1cba6aa6d324ff727041570e7fc3fd2b7a5"
    sha256 cellar: :any,                 sonoma:        "3e2fff0dd0173fdcc036c314c070fd6d0cb8579a012c4a72eda25d57c03423a6"
    sha256 cellar: :any,                 ventura:       "f4be96a9b630d5e03e7def69c991030bd94348e38aaf5045ee63f2c1030829ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e2ee1cfd6730d4ffaa9366623ee56fdbdabb781482c49ea454563f31fab74c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dab4c1c989d7a85aa4b2a0fe98d32952bc132d054aacc6d3d6be5c69334a288c"
  end

  depends_on "cmake" => :build
  depends_on "spirv-headers"
  depends_on "spirv-tools"

  uses_from_macos "python" => :build

  def install
    args = %W[
      -DBUILD_EXTERNAL=OFF
      -DALLOW_EXTERNAL_SPIRV_TOOLS=ON
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_CTEST=OFF
      -DENABLE_OPT=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.frag").write <<~EOS
      #version 110
      void main() {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
      }
    EOS

    (testpath/"test.vert").write <<~EOS
      #version 110
      void main() {
          gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
      }
    EOS

    system bin/"glslangValidator", "-i", testpath/"test.vert", testpath/"test.frag"
  end
end
