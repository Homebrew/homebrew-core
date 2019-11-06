class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/7.11.3214.tar.gz"
  sha256 "b30b4668734328d256e30c94037e60d3775b1055743c04d8fd709f2960f302a9"
  head "https://github.com/KhronosGroup/glslang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fc2ca716eb2599052b377cc7eecc7ab42112d096bbdfa10756b303af5297edf" => :catalina
    sha256 "a62ffe30f1d2b726a20d558679d9061d513bce025f31551cc2b218e744f8e7aa" => :mojave
    sha256 "0ade09ae5c51996b8d661dcd2f03164acaad6bcd8bde1995f960370c7d5e88d1" => :high_sierra
    sha256 "1c3d394fc3efcfcac63f8f1656bb12749cde4da1962d13eb5b657946d51e3359" => :sierra
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
