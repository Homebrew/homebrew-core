class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/19.08.tar.gz"
  sha256 "78f66af91ec45fe93c0aed9ad40f5ebb226f8ee1e12ec61ab9da6349dc9188a8"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "448005e38d9d812af6fd64c2a5b62eb685a6b6fcfbd1f969464bc3e70cffa742" => :mojave
    sha256 "a8ea280f1560f8d451f637e596da32daeffaf934bb2a963dde6092c1bde6f5a3" => :high_sierra
    sha256 "83350944aab95ce9f0f9657e78b0737c2549ae4b1d21f9dad1a59f5504ff361a" => :sierra
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
