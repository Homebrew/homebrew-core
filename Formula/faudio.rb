class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/19.06.tar.gz"
  sha256 "d65eb9ae2e7b758a134955559953f01c1ad11a08504bd4d6b2d5180ee3563e7d"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "47cc228dd7cee66e80fc57ac16196f8ca14de23ab8de3b7b0d69e41dddfe434d" => :mojave
    sha256 "6c04d055ce7d48dc7bbe17cec7747a737a47191b311ed9330ca1ed3d0b688f4a" => :high_sierra
    sha256 "94d1ef09498f4b4c5cf791e14389cb30ef7b5c7ea6df13f53fdc46a9e5dbd369" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  def caveats; <<~EOS
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
