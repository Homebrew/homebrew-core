class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/19.10.tar.gz"
  sha256 "98bc55b494ac5249a4eed13b77394fa30bd9dac0931d4364616d2e501d987457"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "601470f35aad2e7e0ee58a918a9f47cd50efb3d748aae6e329738f6b7794ca6f" => :catalina
    sha256 "37abc27262cf2b46b4b83ae42a1fa00f02b345a3e7342c52dbb620d06ad5361a" => :mojave
    sha256 "92337a1ca119b077911dfe28941c84f31b1f78cff6ece4a199c3ff4562951492" => :high_sierra
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
