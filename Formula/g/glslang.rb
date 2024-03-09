class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/refs/tags/14.1.0.tar.gz"
  sha256 "b5e4c36d60eda7613f36cfee3489c6f507156829c707e1ecd7f48ca45b435322"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "448f7720033efdeb5d3df3cae267f99d285a6e7844a8f30720d7dc0253efdf0b"
    sha256 cellar: :any,                 arm64_ventura:  "2fafee214cfe9ca418df4a63ef2cabedd4049586ee41de1e916657eab771ad89"
    sha256 cellar: :any,                 arm64_monterey: "795b3f198841eb5f32de4e08a6ee7249a8b53cce451f01e853d6a4b0cc8e7d65"
    sha256 cellar: :any,                 sonoma:         "5d485915830ec9d82e7a4322d3579e125be19fb05ebef4349f58fef73a0823cb"
    sha256 cellar: :any,                 ventura:        "c9bad75c8653f2b8dfeca8df5dc547c227c32d8dd2fd4b974ba021a219eb08b3"
    sha256 cellar: :any,                 monterey:       "31b4d99ac39ca57ae73a395acd1bf7ad4d3bd601720a2cb94d51e4ae60b45cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65a0ed00688349d7845d4867c596cf9efc55b2d38152a034cffe64dffb9d853d"
  end

  depends_on "cmake" => :build
  depends_on "spirv-tools"
  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_EXTERNAL=OFF",
                    "-DALLOW_EXTERNAL_SPIRV_TOOLS=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DENABLE_CTEST=OFF",
                    "-DENABLE_OPT=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
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
