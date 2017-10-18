class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/releases/download/0.9.8.5/glm-0.9.8.5.zip"
  sha256 "9f9f520ec7fb8c20c69d6b398ed928a2448c6a3245cbedb8631a56a987c38660"

  head "https://github.com/g-truc/glm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4424acb044d7f1de566ab1709d6107ef17f30198a31c988cc80ab80903c257a" => :high_sierra
    sha256 "44c8742891bf12707b9d3024e4dee0b371e7d91fbd4da12f6e1d21242db6acd5" => :sierra
    sha256 "44c8742891bf12707b9d3024e4dee0b371e7d91fbd4da12f6e1d21242db6acd5" => :el_capitan
    sha256 "44c8742891bf12707b9d3024e4dee0b371e7d91fbd4da12f6e1d21242db6acd5" => :yosemite
  end

  option "with-doxygen", "Build documentation"
  depends_on "doxygen" => [:build, :optional]
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

    if build.with? "doxygen"
      cd "doc" do
        system "doxygen", "man.doxy"
        man.install "html"
      end
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
