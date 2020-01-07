class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/8.13.3559.tar.gz"
  sha256 "c58fdcf7e00943ba10f9ae565b2725ec9d5be7dab7c8e82cac72fcaa83c652ca"
  head "https://github.com/KhronosGroup/glslang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2bb03a1dd08c2224c4e95a2fd9507ea905ba6a66bb4a388ce565f72c54abd84" => :catalina
    sha256 "9a5bc1c2cf5585d552053b5a33b82d1dae2770c816e534ad82428a4a352b70df" => :mojave
    sha256 "2c610e28bdf6a2292c3294326dae076909c2f219f09c793418cf31976388f980" => :high_sierra
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
