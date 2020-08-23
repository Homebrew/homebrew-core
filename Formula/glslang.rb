class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/8.13.3743.tar.gz"
  sha256 "639ebec56f1a7402f2fa094469a5ddea1eceecfaf2e9efe361376a0f73a7ee2f"
  head "https://github.com/KhronosGroup/glslang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9db9f4d0af3d3945270e3fcfbb2e502f377f15d76810facf80862093a18b7a5d" => :catalina
    sha256 "24e6cb49dac7d598a0d12e055a67cd036196eb8cfb7f688b58240219e1a144b9" => :mojave
    sha256 "02af3328d6edf389d340d0c106c4366f575e5abf8db478e6b5c6fc99111b2c2c" => :high_sierra
  end

  depends_on "cmake" => :build

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
