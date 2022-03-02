class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/22.03.tar.gz"
  sha256 "91ea309417f6846fc097e06a0b4fb604bf4bdff67455fabc4820cf1dbe0e301e"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "44260f7cd79011efeec18b07ba1f14e04899b7450038d8a93d870e975336060a"
    sha256 cellar: :any,                 arm64_big_sur:  "79cc2a40413f6002b11a001cf50e477f3f052da74a71d58f5c6f3817ada0ae50"
    sha256 cellar: :any,                 monterey:       "4ecaa72d1f1ca90476e3f2e8cd8589d5b0deab1bff72d9049baf17663dba74f1"
    sha256 cellar: :any,                 big_sur:        "98b0bd397a6f6d1b7948ce4eafb95f002595641a0b0b1a7a80a3de7a2a5e8f70"
    sha256 cellar: :any,                 catalina:       "c36e8538ed877963e0dc4b1a8abb64ce54b9bff576d46e5631a0a6364eb4b8dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5808f616fe8908a3a9f7455035c8ac01e001dd9117a8099f7263fc63f478761"
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
