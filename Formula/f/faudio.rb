class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/26.11.tar.gz"
  sha256 "8fcd197678ad1ab5c95f0901c3770d8d76c1d8b1da819f6873db599807ad7d03"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "15bf006ca0ef141361ccde395a3eff0a30c82702fa4cb56b370bfbd1203fad1e"
    sha256 cellar: :any, arm64_tahoe:       "719265e2acf831970d2d962c4760b6001d8b388f0cae672486b2a2beec9a757c"
    sha256 cellar: :any, arm64_sequoia:     "158a48f06ffea69acfe3e37a34b889e1444f32680ec84d41bbf93c4c814bf698"
    sha256 cellar: :any, arm64_linux:       "af27aae6161dcba6fb9e97addea1753fdf786c620845410826282b6975c9d492"
    sha256 cellar: :any, x86_64_linux:      "3539d1e32dc4ee72a6c34cdad437899f99e1206637e961353a3598e3f02f7d58"
  end

  depends_on "cmake" => :build
  depends_on "sdl3"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <FAudio.h>
      int main(int argc, char const *argv[])
      {
        FAudio *audio;
        return FAudioCreate(&audio, 0, FAUDIO_DEFAULT_PROCESSOR);
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lFAudio", "-o", "test"
    system "./test"
  end
end
