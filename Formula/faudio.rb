class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/21.04.tar.gz"
  sha256 "220fe329d2dcf1c4fa929de0a7532ee7f98facf3184ce9d21a21fad1f510bc03"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e6350d3789161f242690e229d954709828086dcbaa3c262d16c0f09b33afdc26"
    sha256 cellar: :any, big_sur:       "039ba15b7ded7053e756f37c0367bd4dd9f2927fd9c351b877f7c7881c6a4653"
    sha256 cellar: :any, catalina:      "40b0458bdacb14449cf088256af3a70cd72c588a8f3685dc41c20b79e3a505f2"
    sha256 cellar: :any, mojave:        "63c501811295f287f37c3588e5a6dbbcd2da89839c3481eb7de6ef9465b2fdf4"
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
