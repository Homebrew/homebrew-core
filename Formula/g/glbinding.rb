class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://github.com/cginternals/glbinding/archive/v2.1.4.tar.gz"
  sha256 "cb5971b086c0d217b2304d31368803fd2b8c12ee0d41c280d40d7c23588f8be2"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "8414c2062a0413be5ce4d3104464d77ded39a971883839f5162d1eda60c1dc9e"
    sha256 cellar: :any,                 arm64_monterey: "6679892b95d63354d1aa3cde01824915003d8decbbe4479a19cea82e31d20be6"
    sha256 cellar: :any,                 arm64_big_sur:  "5c77227ab2d41d56069711ea964f5222feb1d9f1f88228b88ff657131cec9093"
    sha256 cellar: :any,                 ventura:        "7eef393fef969da975966933406213df6d32a9ec757d3a581751c83aa7e0ef4a"
    sha256 cellar: :any,                 monterey:       "53e55b3996a3e0a93dda11fe2060a9fd7e9a15f2b5985938b7c04beca5a49542"
    sha256 cellar: :any,                 big_sur:        "a77f29c6cc40472d39646027e3d9b068ff5cf912edf600087ef4902e30f501a0"
    sha256 cellar: :any,                 catalina:       "6a371e47b76cd227e12699de3e7a095e620150532789cdac48e1c9b59bee06b6"
    sha256 cellar: :any,                 mojave:         "a44cd2f23650ce664d8f61634c27abce3a00f4b5d9efbb10687759a62ca26895"
    sha256 cellar: :any,                 high_sierra:    "ad79687ca8b43832ab27d5a459a71c4cb7e2be5b02d5df15c667ad7689fe38d0"
    sha256 cellar: :any,                 sierra:         "454bfd4f3f6a983a0614f469388cbe27437350d203c61aed34a8c05fa9bb0710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f433dde2dd1326a5d9be03bbc45fcbe33f0d48cee1ea070c17dd878759c87a82"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args, "-DGLFW_LIBRARY_RELEASE="
    system "cmake", "--build", ".", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glbinding/gl/gl.h>
      #include <glbinding/Binding.h>
      int main(void)
      {
        glbinding::Binding::initialize();
      }
    EOS
    open_gl = OS.mac? ? ["-framework", "OpenGL"] : ["-L#{Formula["mesa-glu"].lib}", "-lGL"]
    system ENV.cxx, "-o", "test", "test.cpp", "-std=c++11",
                    "-I#{include}/glbinding", "-I#{lib}/glbinding", *open_gl,
                    "-L#{lib}", "-lglbinding", *ENV.cflags.to_s.split
    system "./test"
  end
end
