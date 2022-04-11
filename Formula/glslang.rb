class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/11.9.0.tar.gz"
  sha256 "d5744adba19eef9ad3d73f524226b39fec559d94cb582cd442e3c5de930004b2"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d36ff2a45c0d734b259e90dcf37c9b245cc64ea3a648f4ed0b3f596603005635"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "978c82606215edc52643da92321b6e14dddfac221a1bf8ec873ce71c47daf742"
    sha256 cellar: :any_skip_relocation, monterey:       "2d5fdac8308224813f8d9823db40ed4d89c242a8c9710f9ba37883766b5b6f5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "829bba8260c3c7c277982f73b6090f831087c1c89851bee49aab07228fa873a5"
    sha256 cellar: :any_skip_relocation, catalina:       "c92a65f5ad771714fb8adbe84bf640e5b665d89125fc0e0471dec28b3e0d47c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3e484e8ccba2def41c4e318d6e4ba792e2217d70c027664e11a2e3618063a03"
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
