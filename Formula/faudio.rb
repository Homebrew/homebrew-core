class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/21.01.tar.gz"
  sha256 "bebe6aa66a64c7d936b44120d59b2bd4aaf6d7999777aa3c6cdb6ccde51ce59d"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    cellar :any
    sha256 "af1c6af27b35bd27494967153e35e341a83c7b7714454978ba952e9f486ff0ef" => :big_sur
    sha256 "fe5bd2477c50bc528e6601cfe147613abdc25b21daeca6f3b4083b4a597ea019" => :arm64_big_sur
    sha256 "e81004eda7a9d552bb1c54ee5cc5569838f4ca42953e4fb06866d541bc80df1f" => :catalina
    sha256 "cf3f846bef2b61e366f5cd0e4acc51cc0faa22f69a5af232fb40a710ba0926a5" => :mojave
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
