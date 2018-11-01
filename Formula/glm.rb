class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/releases/download/0.9.9.3/glm-0.9.9.3.zip"
  sha256 "496e855590b8aa138347429b7fc745d66707303fb82c1545260d1888472e137b"
  head "https://github.com/g-truc/glm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d09df129db16689193b2102111901de81a1eae94efe954320084fcc45c5c184" => :mojave
    sha256 "5c4d2d3dc01a98ad994550aa0e81f2cff45ea32c22fec5104ef19572a6eb241d" => :high_sierra
    sha256 "2bd62827e1691e5285195c183cc43fbdd2a39319c5d32d982b628fc7274d804f" => :sierra
    sha256 "10e0b39c04844526959e11f61b46ad3d99014ab2d4a176e7ebe64573f69842b6" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

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
