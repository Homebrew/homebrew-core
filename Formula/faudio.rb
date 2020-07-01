class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/20.07.tar.gz"
  sha256 "65f63726a06083871abd60e69d94f1df2d9f6f4dea8d4d627b0f5d87847deacc"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "51fca38eae3ad1285799ebfc907f5f60223e378cce7b7a8065fe3d37d1c73566" => :catalina
    sha256 "1baffef5100bef44d3611750287f19f0948f4e1dde0a4826e47e86f345c4b946" => :mojave
    sha256 "a3fe52fc2ea8dc1c247f81daa37557496436e40b01227fe5162d15d48161dfe5" => :high_sierra
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
