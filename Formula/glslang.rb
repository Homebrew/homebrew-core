class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/11.7.1.tar.gz"
  sha256 "ab2e2ddc507bb418b9227cbe6f443eb06e89e2387944f42026d82c0b4ef79b0a"
  license all_of: ["BSD-3-clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18dcbc350e0c470597ab19d731da4476d9bb0ffeb53a595ae3d1e566054b2539"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8db4adb630a1dd7aa6ebdffbf1f40b2e0a242796c05687d5600bb77030df92a"
    sha256 cellar: :any_skip_relocation, monterey:       "66fd62ba15cae26af4785b3f19b5e6df8908ac74916a04244f0d1e0cb7109646"
    sha256 cellar: :any_skip_relocation, big_sur:        "32c157b0c7213d762d2f6363c453d65f660b3c15bcff844d70ef4310178b034b"
    sha256 cellar: :any_skip_relocation, catalina:       "3144f925b87731a1c7c5923faf76dbcce1167d411ad57651193ab613c283553f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9af76bebc45083df5fea521ea48f2a95d77abd6d431d4fe82130cb550dded9ae"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

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
