class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/releases/download/0.9.9.1/glm-0.9.9.1.zip"
  sha256 "10f1471d69ec09992f400705bedc9f5121e17a2c8fd6f9591244bb5ee1104a10"
  revision 1
  head "https://github.com/g-truc/glm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed0abd7ac4c09b0e34d00c7c72800645dea2adb361bb529885ea9ad9775af671" => :mojave
    sha256 "3edc376c8c288f2693f871d87bfb574cffcf92815defeac8eeb593dd01f1f3c3" => :high_sierra
    sha256 "3edc376c8c288f2693f871d87bfb574cffcf92815defeac8eeb593dd01f1f3c3" => :sierra
    sha256 "3edc376c8c288f2693f871d87bfb574cffcf92815defeac8eeb593dd01f1f3c3" => :el_capitan
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
