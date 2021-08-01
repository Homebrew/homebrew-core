class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/21.08.tar.gz"
  sha256 "42a3a295da44721c63f06fcbf5edf8077a42fdb78313b9e1c065afad12df8063"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4540155029d1219f16b61357052bf0e696bdb150462a8c268207787ce66f98c6"
    sha256 cellar: :any, big_sur:       "4b3f6d12a276ee16cf89028408427ef6534eac0d447d0d73de9ad257f59f5941"
    sha256 cellar: :any, catalina:      "845d60e3e2aa2682bb61907c0828069193605df07789ee22cb50736603d46104"
    sha256 cellar: :any, mojave:        "981c005fd70a5a381a1da4c68adc68f58e4579025396ca05d72e8b1d69c5a0ab"
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
