class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/25.07.tar.gz"
  sha256 "78d115d49faf176fedc1f325cbcbc8890ebc8fb6241996c087ba8e41e2ba4dc0"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e933a69946fc15d6c5be412a12873dabcc6470acdf8c81d73bb5b944b3818daa"
    sha256 cellar: :any,                 arm64_sonoma:  "03b072117c1c3ed32755bc496b7a72bbe39966598a4c81d44085db478c4ba921"
    sha256 cellar: :any,                 arm64_ventura: "cb7c27fc9d778eb724d8cb3ea4f392b3ad5340c9f953a7481565681461ee7479"
    sha256 cellar: :any,                 sonoma:        "45cc7a9008e0fd2d6583e1a6deb0ea8c2728b50dd8c9b9df3bc43d4bce25db3d"
    sha256 cellar: :any,                 ventura:       "fbf8b13a7873cbe02c5f4e9f95321e14cf2984eaf1b1783c7e0d960c3e413c6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8df72995d4330553c65e8fe31a71a0d71e1609aef1db46d680248a3e64436d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55a4c5c55586b3f8d1f910b89136bc0abfe84933fb3edd7f303db99e968470fa"
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
