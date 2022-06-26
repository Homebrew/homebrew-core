class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/11.10.0.tar.gz"
  sha256 "8ffc19c435232d09299dd2c91e247292b3508c1b826a3497c60682e4bbf2d602"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1215ac55b90a877f50e35d7fb6400db07954f001a19a832808dd99f5a5b69128"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "992af6ac68c72b6402707d628ece9009e7c4c3d792ba78773a2bced000e0c5a0"
    sha256 cellar: :any_skip_relocation, monterey:       "e24d29d88cf2dd79b390e0ba44941df7b967f3497d4a14d038a2819ba5d99f56"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa6b3399af0503d4da750997e60cb90f2ba0f4815867d2b7ae0da977de229413"
    sha256 cellar: :any_skip_relocation, catalina:       "01bb753829b181d6ed04cfa834f3b2d87b9283a55c9197649b7572662d7e4ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b466b8cb62e7fc6439a39738f2d9588f9d404915b09a5b742db9a03283e7a413"
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
