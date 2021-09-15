class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/11.6.0.tar.gz"
  sha256 "99ecd3a0c2c2219293d76723846f762a9f3e7dd0dc2a4f346d0fc3a05a0ce000"
  head "https://github.com/KhronosGroup/glslang.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "132cdb7d5c090004c963701ce8e527d275f2a57d3347f478b9d1f0b009ac6a61"
    sha256 cellar: :any_skip_relocation, big_sur:       "8376cd3b9a037924b1b64ec7b6af75c969a75317f18fc097b0d3b39d997eedf8"
    sha256 cellar: :any_skip_relocation, catalina:      "9bb22007ee5fc49d03338ac8acb6e4f13f6f287a58e248cf22cfb7608a12e55a"
    sha256 cellar: :any_skip_relocation, mojave:        "27f0831624af796aa827c70d5a245dd28fe38cb756ed7bc9b43a3dafcb599952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd5204468154f780f0bd4206ec493e8b0201821fa28da703d3bda37978966047"
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
