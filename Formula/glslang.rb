class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/7.10.2984.tar.gz"
  sha256 "d0afe88034577ecf06a825db1a5e8222d949a38d3b19c5ce002b90b66c403f67"
  head "https://github.com/KhronosGroup/glslang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd7f8b26b43a668a6570784b8f1d2862eacee26fd224c0c73d4b0ae878e0ac78" => :mojave
    sha256 "72d7deed2a4a8d903245daa88f1f3ff137d88bb46bd9c98cbdbf1b3e292a2b1e" => :high_sierra
    sha256 "e5daadc8d02de6fcf42d68d73ce735e50cc844a051cad61b27766ca5a59ddcab" => :sierra
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
