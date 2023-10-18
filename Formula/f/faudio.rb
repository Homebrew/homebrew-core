class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/23.10.tar.gz"
  sha256 "eb111e76913c60ccae50607a8191efeade09837b3bb08ee66f168488ab714d56"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1317bb66e5ceeac063e7f0bb8241e15bdd66fbda88a0c135a80a4ee082826b04"
    sha256 cellar: :any,                 arm64_ventura:  "e34da1d8f7fb62d107bd15c4297d781fd87c0b65ba2c10e4826d74e170ff3147"
    sha256 cellar: :any,                 arm64_monterey: "34338db14c8b6b7ffc9928b36ee021b0534ba7216d5b0dd58dc494e1bc899188"
    sha256 cellar: :any,                 sonoma:         "a7081da65d241659c5aec24e5fecf097900f932e431c8a1b4eb426e12521c61f"
    sha256 cellar: :any,                 ventura:        "bf8235eedfa56616a9103364e415905adc52df610b7dcc8479ad6029e09fac24"
    sha256 cellar: :any,                 monterey:       "67e6619a76d4e3ea47e0b88b7abda67d319937ada45edebee43e904d21676f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c34b8cedd722c7e4e4d7d458274196d9a15f4ac0841b1312c36ee31467a26df"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
