class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/refs/tags/16.4.0.tar.gz"
  sha256 "c634d6237eb0cc04d5ddf5dc9955daa175d82b0f8797acab45b49965e9f6df13"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  compatibility_version 1
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9138b48c425083e48d57265bd1698c5d5838a189979b2e4ea3f46a9ccf7bd057"
    sha256 cellar: :any, arm64_sequoia: "e66b6b2248d9c421ca4569af2544aeb78956189db6e0c09a71a414b5a5c9de41"
    sha256 cellar: :any, arm64_sonoma:  "aa725e2d32f33b1175a5b35d2ba81931702dc727aa8bef009824550e0f720bce"
    sha256 cellar: :any, sonoma:        "ffcd14e9f1511451a05a2cedb3e970e2b47e2fe1b42b2228de40c3c80e91c6b7"
    sha256 cellar: :any, arm64_linux:   "21f55f74a1f17588534b1a066a51d435c8f23c491efba32bfacba8461660bc38"
    sha256 cellar: :any, x86_64_linux:  "f3b6877876ef2651cc4560c5b24d7ded7bdbdd46cc701faaa3a885973e9ac1d2"
  end

  depends_on "cmake" => :build
  depends_on "spirv-headers"
  depends_on "spirv-tools"

  uses_from_macos "python" => :build

  def install
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
