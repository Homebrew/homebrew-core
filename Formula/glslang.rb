class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/7.11.3188.tar.gz"
  sha256 "0d77219780de5c061ee00c68cc8149f2fef88a2cf31c61c3d1fe0e11ae5612e2"
  head "https://github.com/KhronosGroup/glslang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b183822b71d8765358ae86346d0260112525ec7b5397163873342bf188f87e3b" => :mojave
    sha256 "f84e411da6f48d0c957483a061fc6aa82d571c845374f6ecada3c746f49175d7" => :high_sierra
    sha256 "4d367105047b46b17b277c5c7856b79acd8ad1457c25a61fc1a9a23365f9c3b3" => :sierra
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
