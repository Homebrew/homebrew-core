class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/25.05.tar.gz"
  sha256 "dbcf99a869da402d5f538e435ab7fd4992b2b255c9939e546f1905c3e6e80ff9"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8a66b6593f55a766574e2072d200f32aa81dba6723b88adda278768534da9e26"
    sha256 cellar: :any,                 arm64_sonoma:  "f9396feb918fe8962d786a27b69087666ed0353588f084b53f06d022e9deb570"
    sha256 cellar: :any,                 arm64_ventura: "700906c61d170214b1179189d72bd1b7c299f67732f15cc33a5762ff9b4c0630"
    sha256 cellar: :any,                 sonoma:        "92eb80a75a9519dfe165489e4cc09ef77c7c3c9d4f8e86dab984eae147638e1c"
    sha256 cellar: :any,                 ventura:       "d5810a389ed1680aeeb90c8efe431b577888150852ea4a5a9464f7912aad3c6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b59b4e4315c5644edf9342f8951496b7649c42042f679a9652d362f74ddee92f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "167ef9b4a6556650d17ff4e5629922bb102076d95f66e86b7edd4b74f3519f24"
  end

  depends_on "cmake" => :build
  depends_on "sdl3"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <FAudio.h>
      int main(int argc, char const *argv[])
      {
        FAudio *audio;
        return FAudioCreate(&audio, 0, FAUDIO_DEFAULT_PROCESSOR);
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lFAudio", "-o", "test"
    system "./test"
  end
end
