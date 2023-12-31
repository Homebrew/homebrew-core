class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/refs/tags/14.0.0.tar.gz"
  sha256 "80bbb916a23e94ea9cbfb1acb5d1a44a7e0c9613bcf5b5947c03f2273bdc92b0"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6160791f3bd4058b2f3885f81f82532aa1c0e364dc18760b4b706393c47a50e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c95236b71f9a90a791bb3c387dd15328b05bd3aa467ad617d0e052dcf7f8a8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d28f7e7b2a7ea148db9b37fb9d5f72bf742dbb286d668671b0a9e98afe459346"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe5ddc93e77c0f0a07d160da018514069bb5df7a11b838a5abcdff353092ad25"
    sha256 cellar: :any_skip_relocation, ventura:        "f233ac2cbf0eab3299dbe6e21c475f4ab68a1481a972121f6b6b7e72b1822130"
    sha256 cellar: :any_skip_relocation, monterey:       "fb3539885cdf728ed4a7aa583d0f024e0274ea2a180b74e0fa5ddced63d7a8ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59668a27552e7d7f939a4a9b2bb66fd328cf96ebcbef140c7e0fdc832cf50981"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_EXTERNAL=OFF",
                    "-DENABLE_CTEST=OFF",
                    "-DENABLE_OPT=OFF",
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
