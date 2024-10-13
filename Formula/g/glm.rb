class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/archive/refs/tags/1.0.1.tar.gz"
  sha256 "9f3174561fd26904b23f0db5e560971cbf9b3cbda0b280f04d5c379d03bf234c"
  # GLM is licensed under The Happy Bunny License or MIT License
  license "MIT"
  head "https://github.com/g-truc/glm.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6609c947e9ae4ec7c62ddd7ad0d2d64b65283675b57e6f5ab9a19194a607170a"
    sha256 cellar: :any,                 arm64_sonoma:   "6ca85b0488bb2907b912c68c5720934164d86afe6b038cd9467a78f06122f75d"
    sha256 cellar: :any,                 arm64_ventura:  "ccf69c567c8790a7c1efb53aa3b940f27f0bfcef50c31b486208c85eb77e37ad"
    sha256 cellar: :any,                 arm64_monterey: "7aea1476f18c285480341c410a24955a05cceee4f664a720bc3457d2dfac2f0b"
    sha256 cellar: :any,                 sonoma:         "f5d0210c66b9780f30ce6429c1f05bd29f60c6ccf93e16ad12aca20ac9af1079"
    sha256 cellar: :any,                 ventura:        "17c95c99013f142a9e48e3c557705c74d19e9de27b730c9f49a295183fe9d3cd"
    sha256 cellar: :any,                 monterey:       "27404b50e8c5ea47840a934e470a170e9846d4e20a60906e3545eb026c144345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4bb112c557b415df7d766a89422d73e6f6d10071c7e5750a54f5152f1603074"
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
