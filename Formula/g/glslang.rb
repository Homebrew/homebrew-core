class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/refs/tags/16.0.0.tar.gz"
  sha256 "172385478520335147d3b03a1587424af0935398184095f24beab128a254ecc7"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "403606d4855a4e4c8071dbc9f6f6df51fa1c53e14573b783583c42054ef2a299"
    sha256 cellar: :any,                 arm64_sequoia: "7f527689ae78e572f27273475c4cf63f661d0bb65ee413e91c388e6cf0a0bd1d"
    sha256 cellar: :any,                 arm64_sonoma:  "7fcb73300286a2484c5b0ad9dd027dbd97b1c28776401d2ff1e511de5346c8ab"
    sha256 cellar: :any,                 sonoma:        "b98f09a34b0ed9998c6d430ed4f34267636ad382b6c2a20f096331e4562b7712"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "102f3be0df1816cf4bddc073cb2f312933a4b1cb977c9512d3014e53fc5d1c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bef3c426dfc5b72cd05bdaf204d91e19f2e99d68afcf1a5d4660b8c37405f9b"
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
