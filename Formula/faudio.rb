class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/20.10.tar.gz"
  sha256 "5db56e58ca3f8eb6d10f01970f122798ebb366dd1b4d7561f65d05f815cef3b3"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "3aacd4333715529a76f1431c6e66d7b8c2e3079f42b27cdb125d03e00c5f91ff" => :catalina
    sha256 "faa8d5749e457338f73b4a9a888bb4685f5cd1806a767252f391f067883671c9" => :mojave
    sha256 "f058379dee95b267af4609a52890b6a4e922dc01b8ffbd75c6a5a85eb35a5d82" => :high_sierra
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
