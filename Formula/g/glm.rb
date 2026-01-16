class Glm < Formula
  desc "C++ mathematics library for graphics software"
  homepage "https://glm.g-truc.net/"
  url "https://github.com/g-truc/glm/archive/refs/tags/1.0.3.tar.gz"
  sha256 "6775e47231a446fd086d660ecc18bcd076531cfedd912fbd66e576b118607001"
  # GLM is licensed under The Happy Bunny License or MIT License
  license "MIT"
  head "https://github.com/g-truc/glm.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8249c4e8338f0d834f967436fd7dbd239ba6dec2117716983a3fe54a5d091ef5"
    sha256 cellar: :any,                 arm64_sequoia: "fae85fca847469c7c7e71ea2ef03f363ac98d3b95855c6eb444ac9ea22f7b96d"
    sha256 cellar: :any,                 arm64_sonoma:  "81e11f0978855c2389d2283042e0c33e65ac04dedcf19743d3e7b89040abe5ca"
    sha256 cellar: :any,                 sonoma:        "86c4b9d9788fe78f27caf754e87ae66e85c420e728eca547afb8512eaa66c906"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb411dab3df676bd1e7150c3ca6c76048cef96dec5fab02499701fd4ca5a7006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3a08b5ba3b2bbd1afce59a27bb1957dc4e5f96e1f573771998b2efaab6b7adf"
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
