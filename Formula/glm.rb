class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/releases/download/0.9.9.2/glm-0.9.9.2.zip"
  sha256 "209b5943d393925e1a6ecb6734e7507b8f6add25e72a605b25d0d0d382e64fd4"
  head "https://github.com/g-truc/glm.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bfff1210011db0784e9ca382b22c73c303095ec427e42c3ae7948681d8ddc00e" => :mojave
    sha256 "a08b7177f060604dfeca9ba56be35d28ed7fd85652589f0da7a37b9caaa845b0" => :high_sierra
    sha256 "e6800f01c463ec8250acb7bdfe24c8db8d30324df0d2934ccf91c0b0f3d947e6" => :sierra
    sha256 "7214934e63d1c5b6f0e791e48edfe710e6472a157fccc5f038618bd373ea0801" => :el_capitan
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
