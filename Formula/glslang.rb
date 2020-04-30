class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/8.13.3743.tar.gz"
  sha256 "639ebec56f1a7402f2fa094469a5ddea1eceecfaf2e9efe361376a0f73a7ee2f"
  head "https://github.com/KhronosGroup/glslang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4a3461d76f138a80ce27d657ed97cfd3522fbec9ff154230ca82278274f0a97" => :catalina
    sha256 "f3cb27ac91ec3f5d53e40f83629592ca21b3f44c1b3ff836d829761838b60da1" => :mojave
    sha256 "e113abb11c68625c53549852f9c59a205c0eaca994dc6bd09e94dc23cc5fcf5d" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

  def install
    args = %W[
      -DPYTHON_EXECUTABLE=#{Formula["python"].bin/"python3"}
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
