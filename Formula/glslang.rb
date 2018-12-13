class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/7.10.2984.tar.gz"
  sha256 "d0afe88034577ecf06a825db1a5e8222d949a38d3b19c5ce002b90b66c403f67"
  head "https://github.com/KhronosGroup/glslang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d244d25da149e9b3cd3a84d8a7ba1885dc59ea44968eb819ce7a0fe2ad94bc9" => :mojave
    sha256 "92209d6ec593c1ce0faf4e9d50365e020ac3bc8fc27ab74d698623877c9edf7b" => :high_sierra
    sha256 "ad520087b809004564b0b6f9e336856b5b68d6008db3b56e28da961ef9e9ee86" => :sierra
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
