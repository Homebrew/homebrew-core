class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/11.8.0.tar.gz"
  sha256 "9e5fbe5b844d203da5e61bcd84eda76326e0ff5dc696cb862147bbe01d2febb0"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "356d8643bd47d5491a211f08eb60b71906cb130ce0410f022bc9f20047a1e125"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41ebe421a85b8d4e4db6d476229fc0ccee58c235d663fa842c6a25d693ade86e"
    sha256 cellar: :any_skip_relocation, monterey:       "81d64330922d10a64c39cbc1079d0c9722033df07072e97d5f8f29d3eeb60153"
    sha256 cellar: :any_skip_relocation, big_sur:        "76ffccb9839cc757d9549dd48090f139d240d44f9f27e87834d1dabb46b33fa9"
    sha256 cellar: :any_skip_relocation, catalina:       "57299a244ba4da3aca66912f11c7b0a902e498d15d257ad31da9ec3942dc6bf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "455298aa998f5f656feb5526f5846a2d950aac9fd7cdba95918df9795c346e5a"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

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
