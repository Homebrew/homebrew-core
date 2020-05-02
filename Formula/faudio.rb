class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/20.05.tar.gz"
  sha256 "62e68c61970552f27f0bc4943bf92af5f4b9ae2a30ed4fa70784e1f7056c6625"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "ddccd539054fcc2f15ab100813c04ef4b99cee3b883a981039d073fcde079151" => :catalina
    sha256 "57cdca1ce8478e583ac6ad15de5a8e8e61f149ac14e1502d5ca74f87120f6bda" => :mojave
    sha256 "5a4a68c47a341418be117d144cb30330d054ebd5de9e00bdabdc5d58f913b7af" => :high_sierra
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
