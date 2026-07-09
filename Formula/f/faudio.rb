class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/26.07.tar.gz"
  sha256 "e136e9d0a96609f88405f2c479bbc445d7b058d5134247674257530bf7210986"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "00dba8f51f3de6f6fc485745b83d39c7fda317bf94bc95b26bf8a914986d9c75"
    sha256 cellar: :any, arm64_sequoia: "b38e76ee344a9920d44e27e533b0d794cd36a2db731d08f1cfd80f1033c17ddd"
    sha256 cellar: :any, arm64_sonoma:  "fbe59905bda8c7e146b93f62ae6da047abb9e16648e0d19e45e1e7141be7294f"
    sha256 cellar: :any, sonoma:        "1514728138e7d079fb8a07b6f11ba9ca131782455968a048e991e2c99e2fbccb"
    sha256 cellar: :any, arm64_linux:   "6a406bf5be9ee933726cb4b103abc3cfca7c1d2d57db800ec91f424f7058803f"
    sha256 cellar: :any, x86_64_linux:  "eccc1bf009c3048d7fba229c4d6dde6c3478900070cacd61028078e17c379c53"
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
