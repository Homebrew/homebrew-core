class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/21.04.tar.gz"
  sha256 "220fe329d2dcf1c4fa929de0a7532ee7f98facf3184ce9d21a21fad1f510bc03"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8030a7d6682f5e667d530f98f36dc199022c73bb9fac3ee0ee822a5c5919ee5e"
    sha256 cellar: :any, big_sur:       "7bae64c4e8ad61e603d6fef3df3ee465646da0055f53a41700a16fd5cc2b139f"
    sha256 cellar: :any, catalina:      "2e7465e5794deaa2da9ac594f2ff97b0dd48fe2076657d0f2a13ff867258be4a"
    sha256 cellar: :any, mojave:        "890a782061c15d2b1feaecfc13baf348b2971c8ea7b291a665012cd284c9f6d8"
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
