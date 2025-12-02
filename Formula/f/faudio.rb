class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/25.12.tar.gz"
  sha256 "16cee710de4a9b130b2eec8bd2a7ae8b0cfb83befd9633e9c7107aec403b17f2"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "89371e1190f8b1ee04cb2a91f85b415c3f29af532716384745bfc817cfe583de"
    sha256 cellar: :any,                 arm64_sequoia: "fa7e4700e9f788eea1871c409be6417386dd038fa9fcb31cbb45c548f24a8adc"
    sha256 cellar: :any,                 arm64_sonoma:  "f431bfc38e8861cf4af6c86a4ebbe7ac320d9a1ec097da06721c77710b9ea2c8"
    sha256 cellar: :any,                 sonoma:        "0e8dfdad8f997ea4a4b66428eb992ad7ff922cb5072928c8f8948cbd35827c44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f9b466c4928827487cfd5c390cd5deba68ff890a057790415df7901ceee9239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9c484bf8cea9b258ba1b4a50584a72cccf9d2e7a6c2eebee66b0fa76aefd783"
  end

  depends_on "cmake" => :build
  depends_on "sdl3"

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
