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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bc7e69b382cd909ad211e53996b9e45f31b776f369de4f80ff2ddd8b3506479"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aee6accfc43b01ff82a6846967745e40ee6a55624b7a658e58d85d3cb2c7fc2e"
    sha256 cellar: :any_skip_relocation, monterey:       "cc6d5b07febfdf260c09dc2b3b5679d666ad7ce66ca0903d3f27e4464d19d793"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bb91a121866b43c730066d23713dec3c7192dfa0d08f5b9338950009608c267"
    sha256 cellar: :any_skip_relocation, catalina:       "731aaa2823df30f9ffb32697487247770705b588050c3e547471d263b24ee94a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a91b542709e475772a5f101912e528304137c3d1421c8a1d4fbcb1e91af74e1"
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
