class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/20.03.tar.gz"
  sha256 "672193396f73cc491543aba78c9fa8c9a541900aca851bfecca6007bcc9f45d5"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "3841ec47f578fc5e3cfdbcba3369c395c41ec7e06f70e2910308903b0376a168" => :catalina
    sha256 "9887757fa2c46d28c174fe09ee9b2b23f13c6b94ec0306ac076361a1fea9ac6b" => :mojave
    sha256 "3f1b806d4b2e989dccb5abf010f2d6a32a46a42d8d4763e10b62fdd049af1b47" => :high_sierra
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
