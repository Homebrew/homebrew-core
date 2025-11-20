class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/25.11.tar.gz"
  sha256 "8400d2cd3c0895b34238add31427399db72c830bd28533d31fc8335123c7404b"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba8cf07b405cb07d8604ced8856caa7e9471a4119b63ed81433d41db366e70cf"
    sha256 cellar: :any,                 arm64_sequoia: "1052774fef2a46a64d49ffb6ee8214cdfdcb6bb9f8ca08726791d67502417b9a"
    sha256 cellar: :any,                 arm64_sonoma:  "1d8e1de9b7d4ebc16f72b91ecfa79773e0cfca2e56145fde6cc94a59e384efde"
    sha256 cellar: :any,                 sonoma:        "60fe52964fcffbc91245d738a01d9b4f155a40ad6574d0e75ddeda97210ec8da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4a39ea2f3b055380be36144bf40cff72f2856ce136d1b40a2c1146d2c95bcfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "265e76df8bedd64a2ed9f46a1b5f272a026ac8eb681e7329e188035b5893acd1"
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
