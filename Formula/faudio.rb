class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/19.10.tar.gz"
  sha256 "98bc55b494ac5249a4eed13b77394fa30bd9dac0931d4364616d2e501d987457"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "f4f63df173740b8273b91c7f88337d4eedcc8bfd311856d0b9a1fd0b1faf4836" => :mojave
    sha256 "e5a01018f884e27a4658bceb91fd2ca4b212599266b063feeaf5e20568531640" => :high_sierra
    sha256 "49a4a98a7e37a9613e440605dbd692a9e58cbcca000d4d227e2fce47a716ae81" => :sierra
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
