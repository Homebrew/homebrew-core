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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a4e0d3139593eb08c316681e1a1e7535ef69e7caf443884ab1527441fb7322c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06c69bc5bcce7ee7107328cf20351c5ceca9c8aac24795d4e8233167fc4f9b73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfb48eab39a7ba8c29dad0cc7b6b9ca98c88baf34dc7f5afc81727aee471b4b2"
    sha256 cellar: :any_skip_relocation, ventura:        "dc4516622bfb372ec7c1e22430de67366ac21ca8bb502b8651d2f431af825cd6"
    sha256 cellar: :any_skip_relocation, monterey:       "7b6bcd8eedbe6516e1ca49545f6f62f6ce68107db8fb629ff306a2b4a76b2bf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "498cfffce41119aec5d53b423e169d94fa3752af9243ccae01e76908e3da92ec"
    sha256 cellar: :any_skip_relocation, catalina:       "6de7e73673ada9e161aca6243d12d89d00149c2d5fa66bb0c0707e13047906ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "904ccb444848bbfab74e3534a0d2504ecd2c2e11343587dcf174154620229141"
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
