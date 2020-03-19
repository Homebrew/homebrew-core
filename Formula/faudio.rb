class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/20.03.tar.gz"
  sha256 "672193396f73cc491543aba78c9fa8c9a541900aca851bfecca6007bcc9f45d5"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "204e969f8b5c1d9097f01970df08cd11447ae542bc2305e6403233c5675011bb" => :catalina
    sha256 "be3eae87d203db44c2b8b1b78f67f9353103aca4edd0c73f365ef5d5e1a26a23" => :mojave
    sha256 "d842f0526a58de2fa24a82c0940218e93d3b2eb7c30651f71d7f0cc4b71c1872" => :high_sierra
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
