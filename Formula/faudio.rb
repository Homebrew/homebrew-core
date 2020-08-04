class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/20.08.tar.gz"
  sha256 "5c3409fa0e532591f0ab4de1ae57d07cc345efa5cbe83ec25e9f5ba180f920f4"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "a523976a3b6e59227cf638314d44c54b7cdfbfd349afb3b71006b90f9e6eab97" => :catalina
    sha256 "0c8a320b218afe036f268e7fa15066bcf23d3a2551cbe246cabb9579c8854b5e" => :mojave
    sha256 "771de3f90de788ab81f195ac788662b796007692158ca441742c605d4c2ea5fc" => :high_sierra
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
