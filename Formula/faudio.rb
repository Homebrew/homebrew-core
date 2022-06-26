class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/22.06.tar.gz"
  sha256 "6cc2480a191ecfd6a2b6c57af3c21307ffb8a4d4af95769386590e9a33ea1750"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "338a5f7d301c9d1ccbd7beee0a51df9ba34ea3bc040cfd36b1be93dd0b24b386"
    sha256 cellar: :any,                 arm64_big_sur:  "03e1815e54b90a235dfb2fea5f092b69755fbd4635375726f96581ab0f6ac161"
    sha256 cellar: :any,                 monterey:       "3c933f20583b33439d5141c349b1d69b8c9ba3389fd7cd0a19e1e74880b1f0c9"
    sha256 cellar: :any,                 big_sur:        "94f97b67c2e4abcaec6b50d461ab11420f4fb75d67e02d58126932c05cb5c84b"
    sha256 cellar: :any,                 catalina:       "342a3d4bf4ea456b7ebb0fbbf2b87f97f7f519fe513ca9e412c6e117548a59e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa8644a9c43ba875d316632c0da6d9ebaf880ac76761cb3fe40609f235561ac3"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
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
    system ENV.cc, "test.c", "-L#{lib}", "-lFAudio", "-o", "test"
    system "./test"
  end
end
