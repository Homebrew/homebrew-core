class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/7.11.3113.tar.gz"
  sha256 "4d238000162029f791cfcd65a28f10defa574516b94d9392695d27c8a1ce8b62"
  head "https://github.com/KhronosGroup/glslang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ca76557225b4f2b1581e2871d4776a40e6cf01c07c050cc5ce75f4b03588414" => :mojave
    sha256 "84888dad40357579e1c982643f5f3a00dcd5366e88f413529091934b537d16dc" => :high_sierra
    sha256 "8f443eeb28c81961d140fce0272cd4c2bb4a128cbbf13418574e51b71b44ff09" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
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
