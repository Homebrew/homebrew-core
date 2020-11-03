class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/20.11.tar.gz"
  sha256 "551f1573a98082973e8e2f0ef14be8f34299c9813d58387f9edd32142e6f913b"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "86ee91e8ae14aceacb8f5c2071bb1558429da10b462a3780db3739547acaac93" => :catalina
    sha256 "c820aa1ce3dca2a113523fb386366188c18bb511de5b9687b893cb441ed6d92f" => :mojave
    sha256 "51e88941cb467d1661137490eea2a9546cfb4abf7485d246733f7cd3074425a0" => :high_sierra
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
