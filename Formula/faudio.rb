class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/21.02.tar.gz"
  sha256 "0b590f8cf29b2333fdb2b4f2a45fcfba920a31323cb835114d95cc2503b516c8"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1b04245fc96837e76295de550b71a6726363c1fefc9e51dcf0e37f302dac02b5"
    sha256 cellar: :any, big_sur:       "1d17eb20201576e754b8d3bded2f3d5c404434f0c7761218417eb67b98e37b75"
    sha256 cellar: :any, catalina:      "c570c1187b5fb6d6bddc23965d18742598947709825d97751770ff0258b20e17"
    sha256 cellar: :any, mojave:        "b087e8546f0979625a76822fd89b3c2e3162eadc4db0ac8ad312a2cc1ede2423"
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
