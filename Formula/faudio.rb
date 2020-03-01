class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/20.02.tar.gz"
  sha256 "103a6d278921ce757e5427133626f60ce4876b30d81186f78af35d9f1ca4ef16"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "87059201186fe549c3e26afdeb57c9c8842959b64c0b37055e5ad590b44601a7" => :catalina
    sha256 "ddf962dc7c762b475a8267cd65ddb01661fb6ccb59d6d1d553855a358ff87971" => :mojave
    sha256 "f3dbf8749263252731a2e8a440431127e57c989942e78e622264330c767f2052" => :high_sierra
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
