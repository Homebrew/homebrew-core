class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/11.6.0.tar.gz"
  sha256 "99ecd3a0c2c2219293d76723846f762a9f3e7dd0dc2a4f346d0fc3a05a0ce000"
  head "https://github.com/KhronosGroup/glslang.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "112df1a4b0cea8b4a1260e30f357ca6fcbe4d78139a7e2540fe579e62f1c1382"
    sha256 cellar: :any_skip_relocation, big_sur:       "1a6c187d34130acbc0da05869d045fd28ebb58a7665160bbb629cf44385e39d8"
    sha256 cellar: :any_skip_relocation, catalina:      "138cdfa0948e7b98a1f9cfec590002abd883ce0c4ce9a1e463769a78c39e1087"
    sha256 cellar: :any_skip_relocation, mojave:        "32bdbcf7595e0a5cd83e84117caca3dd210c0f2a0de4cad1a18a6ee33086c8db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4768d834ffbf9c4bdd64461271c5fb652aec519803b85174d86c785bfc81640f"
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
