class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/refs/tags/15.3.0.tar.gz"
  sha256 "c6c21fe1873c37e639a6a9ac72d857ab63a5be6893a589f34e09a6c757174201"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2574cfc92a1eab1cff6b23bdaa3ecd331e6dccb00f26f0f47e5afa9f7fa09e60"
    sha256 cellar: :any,                 arm64_sonoma:  "4859ce0ef1be9e7f84495d71ed8a7c77be79b16cd21150c686a132a36928c114"
    sha256 cellar: :any,                 arm64_ventura: "022092d34d24bd6c466c4fb58e983e93333cfb78385511a989415f9f444effa7"
    sha256 cellar: :any,                 sonoma:        "70505478f4cc0a2d1279ddd3cbe2f6d08c0165a58c5abde06d3a54ad59d82072"
    sha256 cellar: :any,                 ventura:       "bf5c7a620da27ffe8e699726cd0bf2714df095f486350fd0ed3f49f5ce02d4f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "057e833ade33f1d532e92ea0d2f3ae5cd02ac29f4a1aceef660c1091e0c5cf42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "787c48045e0233ea28b67db07e0aeaf15d0fd05becc2f9d459d7c4695362d77e"
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
