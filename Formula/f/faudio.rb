class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/26.02.tar.gz"
  sha256 "f1fdf0affd5c97080fa98e3f3b4cbafbceb54dafbddfd8d16a06a0e08e1de749"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "319b9cd677912d925fdfb34eefa69f14427b8bef3f5ba20379611f0a9e6dbc6f"
    sha256 cellar: :any,                 arm64_sequoia: "cf48943e2cd36055291efe2ac99941b338865b5f531671c7547ab012ebda8d8d"
    sha256 cellar: :any,                 arm64_sonoma:  "1036ecff42285f6b72a4792b5c1e45036a4bd39d465591bc65f40d52ebfda1a3"
    sha256 cellar: :any,                 sonoma:        "7fac6c0c8a17520ff228940ee64213d62d875364a3def7913004c97f8dc2c1a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c350aad5e031c9144ccb5595628588f31dcd89725950a89339970b4ced2ef88e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f059c8dc35af1c6787b09735f990f1ef53fc8fe62d449367f1bafcd7848c6b8c"
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
