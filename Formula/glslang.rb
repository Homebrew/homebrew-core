class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/11.1.0.tar.gz"
  sha256 "a47f1f9ed17a1f53a074fef20787110ef49522c6de68b218db68d04a81d649c5"
  head "https://github.com/KhronosGroup/glslang.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "83498bc39db8c8c2498fed7c5e1288ca55ffd1054c6cf7133a7d7a9a3e8b09cb" => :big_sur
    sha256 "6afc089ff212425bbb87c05ae07301428b3cedb6a3ebf14f5e6bc934bab8bd63" => :arm64_big_sur
    sha256 "4a048bd36ed9c1f241e74706b3ff4b0bb8129393dc3d651c5509656265c44968" => :catalina
    sha256 "5ec84ea223f671dfc3997a3eb23ee29aa7b2a2ecf23418c68e370aeb083fd0e9" => :mojave
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
