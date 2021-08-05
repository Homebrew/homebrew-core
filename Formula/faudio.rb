class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/21.08.tar.gz"
  sha256 "42a3a295da44721c63f06fcbf5edf8077a42fdb78313b9e1c065afad12df8063"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "07e49b48488a33b2ad7bc3e1312cdbf6bae72de52eb870599a801319c1897a7b"
    sha256 cellar: :any, big_sur:       "30b7ad5f185b807c2eed5387d074db740951bd7860f6343a66fdb688411a62a7"
    sha256 cellar: :any, catalina:      "5dad0ae2b04dea6972d528b1c5a864d41917e9218567eb6e6b2caadace829290"
    sha256 cellar: :any, mojave:        "d0d535518f89a0a7169a52b17e6518c60a00c44aa8efba8dfa278003d10ccf09"
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
