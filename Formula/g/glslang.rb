class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/12.3.1.tar.gz"
  sha256 "a57836a583b3044087ac51bb0d5d2d803ff84591d55f89087fc29ace42a8b9a8"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d32f53806b60877733b8a054cfdebed20c4ab024b0d12f60293d7173d91d1922"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba30ede37b5aeb6ce8dac772e48afe89472a5b0601399134c136f5ad27fde2dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60dfac0253d11e3bb3e4bea1f3b97c10dd8cdd2e3edbf35bbe109ed7164486eb"
    sha256 cellar: :any_skip_relocation, ventura:        "3aa531dff095e45f3e509b23f1425b5ce5d50139ef33f9803e9c41179824ec41"
    sha256 cellar: :any_skip_relocation, monterey:       "48b8e5575c92a72e4979527871f22342abe04ee068ca0d2aebc2fcdfcaeb31cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7c133d9edbbe5d719dfe2a8738bf709a05b0e63c76f83604b60aa084084953a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08cf771bce60b40a83a3f01df0d83daf3f51ed925670f918e246f4212e9e81b9"
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
