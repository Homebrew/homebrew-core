class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/releases/download/0.9.8.1/glm-0.9.8.1.zip"
  sha256 "b27246788d2020c48f146ff84396a6b93001e5bea42c18f8beceaa5c452c5751"

  head "https://github.com/g-truc/glm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d60b60622f241ac37009e36f2fdf832c550f3668b53614e8c5578e6923a952b7" => :sierra
    sha256 "c79290df587f64d1c3913540135655c77ddf1c21d01953b4bc843fb6792ecb9a" => :el_capitan
    sha256 "d60b60622f241ac37009e36f2fdf832c550f3668b53614e8c5578e6923a952b7" => :yosemite
    sha256 "d60b60622f241ac37009e36f2fdf832c550f3668b53614e8c5578e6923a952b7" => :mavericks
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
