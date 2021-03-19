class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/21.03.05.tar.gz"
  sha256 "c396c7c196e47bcb054cdc94cd3f7f39751fe27774de7eb9749a9608883ad5eb"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b19b83eefa112fbee0cdd315c49a7d6424fdbead34880e1c37b881bcc7c2c27c"
    sha256 cellar: :any, big_sur:       "c745166deea7e82d53273d27bb81207888863e7b204500ca4288a1b9ea55e29b"
    sha256 cellar: :any, catalina:      "9be31c43ed68f1ada03078b0920b405c4e9045692218711acc24c0a14672841b"
    sha256 cellar: :any, mojave:        "33cb8da3ded7c582363660427fe2571145b028c9a3b8bd10e55bf7a4cd1f17a6"
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
