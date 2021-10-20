class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/21.10.tar.gz"
  sha256 "eca3e2cc148f9b25e8ce61153f3f552a385cdaa903f691af0a53932cc10cfb39"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "16dbf7e9385bb596654f6ce8218fd28cd6623c7ae87bd1c14ad26b5726b9b20c"
    sha256 cellar: :any,                 big_sur:       "d2f0b7ac1fc3b350fd6d8b1e6c15e1bd79b61d623098dc21eee6420638de2e56"
    sha256 cellar: :any,                 catalina:      "13050963df317b4e65a3ba224ee270f67a7cc39191b3dee5546e5bdb54a97318"
    sha256 cellar: :any,                 mojave:        "c707921fb22d6c89579630c365fe5d60b5ee24d9cc017e05e1d82688a6e891c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67725e7e2de723c3d643530c6815a27322c1df6b46ed482d8c89b01b0add2988"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
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
    system ENV.cc, "test.c", "-L#{lib}", "-lFAudio", "-o", "test"
    system "./test"
  end
end
