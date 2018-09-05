class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/6.2.2596.tar.gz"
  sha256 "fce7ec22e66043fb59e4a3c369445ea8c57f2631a04b6a0015f19a7bc954567e"
  head "https://github.com/KhronosGroup/glslang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e116b2ee03031de4d586f4c828284d4122640e8cf5a4650a1e58f4e8cfc2a89" => :mojave
    sha256 "6c630e225baf6a7db411b206dd1de58fb8c71e58cd77ba399245fad3f451db76" => :high_sierra
    sha256 "75d77271b5ad6ddbbe7579173eef4af2960610179897783bab4b9cb59573b56d" => :sierra
    sha256 "23844f7700b35bd8fe85a1f1559a16250f5be8042ac89c77003a0e0082c08782" => :el_capitan
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
