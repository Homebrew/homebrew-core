class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/11.12.0.tar.gz"
  sha256 "7795a97450fecd9779f3d821858fbc2d1a3bf1dd602617d95b685ccbcabc302f"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2642e6dae9537c64785a85017302fa8f80c785a366632543ea97b351e4670de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e3e7ba09d8b4571da00f751d4a91b54cd644c83366a3978cd8995518a8ab19d"
    sha256 cellar: :any_skip_relocation, monterey:       "28723ec2e6c24398ac5fcb18a324e94b0126bc62939a4c8bb2bded3f0ef398a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "68688c0872092f0a6d4fab0a7f7f50360c879fde7bd489c639c87c586c54ea6c"
    sha256 cellar: :any_skip_relocation, catalina:       "bf4b0556e69166103a11c49545ec1368a54923c84f3d37ef6e067441d5441ae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9859d656ba647c09f8ce03c39e0d6505b10e7e4467ccf9e7cfb1dc044dab5232"
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
