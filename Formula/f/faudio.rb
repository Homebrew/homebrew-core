class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/25.02.tar.gz"
  sha256 "eab667d231e5036b0e5c3c6f89fb4ea792284493d46161bc056a88a6dadc2683"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c5ddc65032959353037a3d3440a8793ce33a9f0eb34e2772c76da6ca4b480e56"
    sha256 cellar: :any,                 arm64_sonoma:  "8f8f65559fd27ef6c8939611141f6490590dac09fae288809b2ddf7615ad522b"
    sha256 cellar: :any,                 arm64_ventura: "8ce5ca377bce289f2ef68edbf8d816de94a848ba1e6bbc49bbf3cf4b31a6d38e"
    sha256 cellar: :any,                 sonoma:        "2a1d5c9c0033ef2da5b6231597eb9bdf3930835710ea7aed03afe0d4f0bb6861"
    sha256 cellar: :any,                 ventura:       "24b42dd2ce7bc24eb73abe87e77e5eef0d36833caf11df109e4c5d0551aa2839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a764faeaf626acf91a8fd36f5edbb6139fae473feedeae7131147bc3fe07a10"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

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
