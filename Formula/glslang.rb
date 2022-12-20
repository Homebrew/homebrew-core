class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/11.13.0.tar.gz"
  sha256 "592c98aeb03b3e81597ddaf83633c4e63068d14b18a766fd11033bad73127162"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c0c6bf49c4b50a348a776bdfc81b774ab8db87d93b1f34183f413855d70495d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bd3f26776ffaf96aa2ba8bdf619b8ed97aaeccb244cbae62164e93ff2e5718b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9799e9a7d6441a675986eaad6e942a0962dca87630ad991b84e316bef9b89442"
    sha256 cellar: :any_skip_relocation, ventura:        "ad2e3bb2a103aed34960bb60e24ff620aa7bff0c5271ae9193e77e19ce0b959c"
    sha256 cellar: :any_skip_relocation, monterey:       "91baac24361a856059b445b7c5c5ff3c077bbf19170c02a1ab88a1b47a350841"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b38e5173d579dfe3918d453ceb7a5f980a3f36cbcd236d2a10ba65db75b7663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "217c21f0675685dd5ddc75f3673bf6e4f2bc4daec1f909e3401aa177181f452b"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_EXTERNAL=OFF", "-DENABLE_CTEST=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
