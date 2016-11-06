class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/releases/download/0.9.8.2/glm-0.9.8.2.zip"
  sha256 "760cc94d5d2cd1925a4e85dbc3e3ca4195bca7331d54386e67dff721c2ef0ce5"

  head "https://github.com/g-truc/glm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8934fe32c2a1d99ad4c30f0c380a3c165577650724af5cc846df6ebc5d397d9e" => :sierra
    sha256 "8934fe32c2a1d99ad4c30f0c380a3c165577650724af5cc846df6ebc5d397d9e" => :el_capitan
    sha256 "8934fe32c2a1d99ad4c30f0c380a3c165577650724af5cc846df6ebc5d397d9e" => :yosemite
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
    (testpath/"test.cpp").write <<-EOS.undent
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
