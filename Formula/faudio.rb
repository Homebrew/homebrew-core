class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/19.05.tar.gz"
  sha256 "fb48a729cfb9ad53da5bb54e2726ef0a83e68a0c705b070bcc2b275a316e9ccf"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "75ca99ddc44fb3b92689efd1383ed41b21cab6213acfe0f049951ff2e2d6660e" => :mojave
    sha256 "cfec9c098ef89f7497c4e3235ed4ca43a51d4730b3dbb05ab2aff237a68b2dc3" => :high_sierra
    sha256 "0e457600f79e5a466976931982946f71b6f249c73a0d4d669012e07b461a2b55" => :sierra
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
