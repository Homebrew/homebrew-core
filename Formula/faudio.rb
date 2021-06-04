class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/21.06.tar.gz"
  sha256 "7385980a6a80529f240e3731ece4f66f38919a2a0cba799d608eb2ee08e10335"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c3f689f5878cafeff77ccb5c6e24c159b9516d68b26ccacc80d2e219f9537c82"
    sha256 cellar: :any, big_sur:       "cba2a34925daeb6f52e7bb848bc26d4ddedfead062411982fcfd57d978ed0262"
    sha256 cellar: :any, catalina:      "9cab57528944790f7744119ef2f8153daefaaa888f26fc111f641c1cb1a14343"
    sha256 cellar: :any, mojave:        "6beeee83641b1530157cc25db6c0804efa2877e48fda633cfb6754a8459b2b50"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      FAudio is built without FFmpeg support for decoding xWMA resources.
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <FAudio.h>
      int main(int argc, char const *argv[])
      {
        FAudio *audio;
        return FAudioCreate(&audio, 0, FAUDIO_DEFAULT_PROCESSOR);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lfaudio", "-o", "test"
    system "./test"
  end
end
