class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/archive/refs/tags/1.0.0.tar.gz"
  sha256 "e51f6c89ff33b7cfb19daafb215f293d106cd900f8d681b9b1295312ccadbd23"
  # GLM is licensed under The Happy Bunny License or MIT License
  license "MIT"
  head "https://github.com/g-truc/glm.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8d177748719b95658993ecd43fa12655701a17c90265b21f276cca23692d370e"
    sha256 cellar: :any,                 arm64_ventura:  "2c98bea16ad38d1bfe8aa6c5e53c80902ab810a64ae3fc07737f7fbd68307031"
    sha256 cellar: :any,                 arm64_monterey: "0b88a03a507fc6a844fd031fec6a01ac1564b9dda9e32165c923ff74374f931d"
    sha256 cellar: :any,                 sonoma:         "5bf46f03e749fc17cb2db89b6e8d00e021246806ebafcdd4ed4fc677b533bc3a"
    sha256 cellar: :any,                 ventura:        "ac194c8b7d6d568639ee2a7611c06127003ac1315ac2e9a86fb53ce2ddc5536d"
    sha256 cellar: :any,                 monterey:       "324b50967d56d320c4d47f4f23ac205a8f813b1b7ec16e0278df6f78d77f378c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2aa9340b302c688c807ce9d93aa1b6303e8f018e0bce74d4cd678185caa2559"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    args = %w[
      -DGLM_BUILD_TESTS=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    include.install "glm"
    lib.install "cmake"
    (lib/"pkgconfig/glm.pc").write <<~EOS
      prefix=#{prefix}
      includedir=${prefix}/include

      Name: GLM
      Description: OpenGL Mathematics
      Version: #{version.to_s.match(/\d+\.\d+\.\d+/)}
      Cflags: -I${includedir}
    EOS

    cd "doc" do
      system "doxygen", "man.doxy"
      man.install "html"
    end
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glm/vec2.hpp>// glm::vec2
      int main()
      {
        std::size_t const VertexCount = 4;
        std::size_t const PositionSizeF32 = VertexCount * sizeof(glm::vec2);
        glm::vec2 const PositionDataF32[VertexCount] =
        {
          glm::vec2(-1.0f,-1.0f),
          glm::vec2( 1.0f,-1.0f),
          glm::vec2( 1.0f, 1.0f),
          glm::vec2(-1.0f, 1.0f)
        };
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
