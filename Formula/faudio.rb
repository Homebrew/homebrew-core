class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/20.02.tar.gz"
  sha256 "103a6d278921ce757e5427133626f60ce4876b30d81186f78af35d9f1ca4ef16"
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
