class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/11.4.0.tar.gz"
  sha256 "9bae79c2b640b60474f8944a5ab4aff3af990074636ea2a0a3c97cb86be61dfa"
  head "https://github.com/KhronosGroup/glslang.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "572ee20b79ffdb9810400a1c0b91d1514412bd693671e8691d1c07272dac85fc"
    sha256 cellar: :any_skip_relocation, big_sur:       "d87b0cc55bfdb9dff2ba9903b3ff0e77a84bb2e71aff11fc1403b58504392921"
    sha256 cellar: :any_skip_relocation, catalina:      "2b87fba839e5e1c36ed9710be62eb4ac39c476f230a86726c71251a9e22f1773"
    sha256 cellar: :any_skip_relocation, mojave:        "3cd9f396d9a55e1b039756c67f62e329ad4e184e777391982a92554158c90b71"
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
