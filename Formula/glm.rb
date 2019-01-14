class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/releases/download/0.9.9.3/glm-0.9.9.3.zip"
  sha256 "496e855590b8aa138347429b7fc745d66707303fb82c1545260d1888472e137b"
  head "https://github.com/g-truc/glm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cdbc4d3d92fdfe569b1eebccbaa61cf24e2c0c5e67bd10ea815007e01796e46f" => :mojave
    sha256 "f1c952d3760c940b2409ad95d9c452523c41b8e9b59b267c0a413de67a1071b9" => :high_sierra
    sha256 "1010aea5652827e3d29edf96c2f27a0793955eb2337ba7b044fec3f3c6365249" => :sierra
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
