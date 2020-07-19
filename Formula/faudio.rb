class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/20.07.tar.gz"
  sha256 "65f63726a06083871abd60e69d94f1df2d9f6f4dea8d4d627b0f5d87847deacc"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "b48bac3a76cb47a54902accb281d2b74299e16a2e5516c16ec816fe0b17c952a" => :catalina
    sha256 "5ee9f84c1ac73223b044a03d85e87bcf165a4acc2b4d53ba296a2548c8cb5789" => :mojave
    sha256 "4f8db4b336d1ea0dfa53332f697deb67d15958217efc6cdd180d3c8a4da57c22" => :high_sierra
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
