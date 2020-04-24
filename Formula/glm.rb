class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/releases/download/0.9.9.8/glm-0.9.9.8.zip"
  sha256 "37e2a3d62ea3322e43593c34bae29f57e3e251ea89f4067506c94043769ade4c"
  head "https://github.com/g-truc/glm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "94bc3a8dc77a81377802bf9cb21ae9d394847a85f172eb4675f09d34131f544c" => :catalina
    sha256 "12ad0bff26df5739227bb1f2865c064b46a1e21faa07e77f19c2be4e2abd8182" => :mojave
    sha256 "534081b8d1624708d52a12d75a31b47372c1711c56057b658c0dbf5fa67306c0" => :high_sierra
    sha256 "b7185a79a24187a43750f740ac07686ef144182eb8006ca0deadbbf4dc037584" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
    end
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
