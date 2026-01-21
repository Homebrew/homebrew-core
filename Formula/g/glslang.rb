class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/refs/tags/16.1.0.tar.gz"
  sha256 "32c605822ed63a0cdc2d24f318c3d912fa14e58573aff1d8eac0cf69f1a6b6d2"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ace6b0757373221b39fd4ed33a2bec87fea5899cbee01ff04382f40f1c3de7a"
    sha256 cellar: :any,                 arm64_sequoia: "8042f23fc01d8e37fe3ac7e750fc1758a62a59016b2dc6599e855d92e50d6049"
    sha256 cellar: :any,                 arm64_sonoma:  "9ebf5c788cac2ab25c3e50d08504aea2813d326eed8581d11725699df40c2459"
    sha256 cellar: :any,                 sonoma:        "7b99203d1734e67d201f01117b7791aa5ced7f7beadec704d3c62442b2e45332"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fada9479d1c406eb4b41acd1fe9186ba6c46655a257d5842e305964a410c408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d50d575173774c951769a49d28d497d313bc372b34cc761f5d089f9ccb29cf6"
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
