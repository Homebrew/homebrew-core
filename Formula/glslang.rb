class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/11.2.0.tar.gz"
  sha256 "8ff2fcf9b054e4a4ef56fcd8a637322f827b2b176a592a618d63672ddb896e06"
  head "https://github.com/KhronosGroup/glslang.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f246a388c01f17db48ce3ce01ed422a015315fe989615e9264a2d4a9e64a89de"
    sha256 cellar: :any_skip_relocation, big_sur:       "b1a44f2c156be34a7cff90080be72ae1c4dac9e3ba9da3042234b0150f4b016f"
    sha256 cellar: :any_skip_relocation, catalina:      "85bd75ea05d1538fe839d88b5a13295d5dafa731f4aca7714fd13188aaf532df"
    sha256 cellar: :any_skip_relocation, mojave:        "95c1617386ff2a3ba3ddc76432a0daba9af91ed9fd4f18ac147d937160face5c"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  def install
    args = %w[
      -DBUILD_EXTERNAL=OFF
      -DENABLE_CTEST=OFF
    ]

    system "cmake", ".", *std_cmake_args, *args
    system "make"
    system "make", "install"
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
    system "#{bin}/glslangValidator", "-i", testpath/"test.vert", testpath/"test.frag"
  end
end
