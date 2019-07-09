class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/19.07.tar.gz"
  sha256 "b05ca9cbdaf943deadae124dcc437e1106d525ab7f54b62c74dcb2eaead21178"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "6d02d5684453659cf742706e8c5954a6dae51e66213af49207cb775156b6d47e" => :mojave
    sha256 "ad2322772b5a33eb0e7e680478bba9b0901a3ed1070fcae651df343690cc360d" => :high_sierra
    sha256 "a728098d5ac4c522ebb4196f51475cb3ac86a5658e73e543e6dc67fd5fe3a6b2" => :sierra
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
