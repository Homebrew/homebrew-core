class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/21.01.tar.gz"
  sha256 "bebe6aa66a64c7d936b44120d59b2bd4aaf6d7999777aa3c6cdb6ccde51ce59d"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "f38400e3f0224c007a1f6cb35162e710178973e00f0f36e161bbc58d680ca113" => :big_sur
    sha256 "e1e959b0b5b01375a1f52f19d0fb404c139cc6790aa79d0ff37e000754baaec1" => :arm64_big_sur
    sha256 "582408862db4be341419f268dc2a5a17185030d006f3b283541fb8ac44a2046d" => :catalina
    sha256 "0bf83f3f606d8fcef3e3111d06a092db3a0cf24a5e6a54477487b9d8f1dda8af" => :mojave
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
