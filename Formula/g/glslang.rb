class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]

  stable do
    url "https://github.com/KhronosGroup/glslang/archive/refs/tags/15.1.0.tar.gz"
    sha256 "4bdcd8cdb330313f0d4deed7be527b0ac1c115ff272e492853a6e98add61b4bc"

    resource "SPIRV-Tools" do
      # in known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "4d2f0b40bfe290dea6c6904dafdf7fd8328ba346"
    end

    resource "SPIRV-Headers" do
      # in known_good.json
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "3f17b2af6784bfa2c5aa5dbb8e0e74a607dd8b3b"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1718b3da09df665f37ca130d3d5c584fb174e29feacfcf72399a817fa2c9031e"
    sha256 cellar: :any,                 arm64_sonoma:  "d643e9284edbc89b4e4906e70afd7d06bf3fd2e20ebb9978bceb06e0903a7a30"
    sha256 cellar: :any,                 arm64_ventura: "d2f5ca41a945434e67d0ac6ac48ee1903f24ccb02febd5e2a6b215926fb97ec1"
    sha256 cellar: :any,                 sonoma:        "12987fe9368dfd4a4cfbf9ec2d8be0292fbb199b23fd148260023e895ae54d16"
    sha256 cellar: :any,                 ventura:       "24d32a6307452552ecdf9fcd21c6000b1bf16c3faf2c56370ea5e501496a0be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3968014ff1d39cb6760dddb458c74b05c5d539c630db05ead07b2d2d23a7e284"
  end

  head do
    url "https://github.com/KhronosGroup/glslang.git", branch: "main"

    resource "SPIRV-Tools" do
      url "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"
    end

    resource "SPIRV-Headers" do
      url "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"
    end
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    (buildpath/"External/spirv-tools").install resource("SPIRV-Tools")
    (buildpath/"External/spirv-tools/external/spirv-headers").install resource("SPIRV-Headers")

    args = %W[
      -DBUILD_EXTERNAL=OFF
      -DALLOW_EXTERNAL_SPIRV_TOOLS=ON
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_CTEST=OFF
      -DENABLE_OPT=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
