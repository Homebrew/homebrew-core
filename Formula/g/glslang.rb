class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/refs/tags/14.3.0.tar.gz"
  sha256 "be6339048e20280938d9cb399fcdd06e04f8654d43e170e8cce5a56c9a754284"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "47ec2bd28333f865554eb3345c2725537d0643049628626ecf13f9ca317dbc5b"
    sha256 cellar: :any,                 arm64_ventura:  "390d16183d4dee8ae1e1f8b974189d26cf1bce4db7c4a8dbfe09cb439c927af6"
    sha256 cellar: :any,                 arm64_monterey: "32d3f139cb61c855a13561eb946035355cfc28b48d44a180a8136b93e1c9292b"
    sha256 cellar: :any,                 sonoma:         "3bd7bc3c27df33d84c8063eeb0a88b1927f04b38b7b46993164d22783578844a"
    sha256 cellar: :any,                 ventura:        "87101567327645d36baf33384fdb407e9a9c53ddf95462137bef4b94bdc60b87"
    sha256 cellar: :any,                 monterey:       "af5b88f33e41ac73a0aaeaea12aab26c6590764e7b3213e7551f411fdca916a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4614dd621b0f2792235693a83e5fbb51045d73301df7e6cc67f9b0c384a90457"
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

    system bin/"glslangValidator", "-i", testpath/"test.vert", testpath/"test.frag"
  end
end
