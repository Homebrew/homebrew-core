class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/releases/download/0.9.9.8/glm-0.9.9.8.zip"
  sha256 "37e2a3d62ea3322e43593c34bae29f57e3e251ea89f4067506c94043769ade4c"
  # GLM is licensed under The Happy Bunny License or MIT License
  license "MIT"
  head "https://github.com/g-truc/glm.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3fb20151677b15dfe14e1213ffb9339c497e6168dfc00415c2b89bf91d35c79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4835a0d6b85dd518d3b47830bbae5f45521f4588bd02d3f690f792a6960b9492"
    sha256 cellar: :any_skip_relocation, monterey:       "b5c3ab27388c4c90f518af0889da3a0a65174d370b7efdd74d52411ce5725e75"
    sha256 cellar: :any_skip_relocation, big_sur:        "0533418aa7813363241f157a547604acc2c097790a6ddaff2967ede127e8225b"
    sha256 cellar: :any_skip_relocation, catalina:       "9b661be1f704c2e946dbd4d4f96d58ae82427824ef88d7dd9f0f0cfc3fae2233"
    sha256 cellar: :any_skip_relocation, mojave:         "7210910c6f106de4c22874f3977b1457cea3db6bb03269ea6831ffae861bb80e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "ea41bb7f8f195c22d6f7834c57684412d752e2c72ff795b9056dd90aaebf9d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5c2dbbad2a1f3c87f7dada3710c9404ec33953f84d6793fba3fc39dd2f683a4"
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
