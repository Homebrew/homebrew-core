class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/archive/refs/tags/1.0.2.tar.gz"
  sha256 "19edf2e860297efab1c74950e6076bf4dad9de483826bc95e2e0f2c758a43f65"
  # GLM is licensed under The Happy Bunny License or MIT License
  license "MIT"
  head "https://github.com/g-truc/glm.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "05a06dc75a170c9f3fee69590447f2f69bb84db32077103d118233dc7896e026"
    sha256 cellar: :any,                 arm64_sequoia: "27ae6d2faa2182f30fab3fb0ed1f80f46bdd3c3503087679264e508d212496cf"
    sha256 cellar: :any,                 arm64_sonoma:  "b75dba49b0edfef6d292617d47acde17a848a1472c30a27a0ed505e2c101781d"
    sha256 cellar: :any,                 sonoma:        "a1b897cb22a4c0fcee80fddd1db7f909aa615bf67c8b3d9b337defb2cec56e07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65f2283d562242b9b2f39ff853a1b7811c130e12064889136405c454d0c1003b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01be3766386d6d4343e0744f61bf19bfd385687b0b79f98ae930c5c446eb01ec"
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
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "-I#{include}", testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
