class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/23.07.tar.gz"
  sha256 "9f197b778a69dc70f7fd2def547e87c3f1c369edc03b1d4085feb2742414f62a"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f5f0de08cd4d03e3065b68a0e7b7462361ff7dbb28b17b5f85f9d20174304b92"
    sha256 cellar: :any,                 arm64_monterey: "c994ce50b5e5ec140b6ed7bc0d5cc840965ce4574ce50fe97338435b7de2ecef"
    sha256 cellar: :any,                 arm64_big_sur:  "a35b3fd7efcff9f0026e016d0abf5ab208ed151274c3a0158ac2d07387469e34"
    sha256 cellar: :any,                 ventura:        "06a59cfd15478fb899e51546e1f763fb08311aca8633e34307c2bfcde43ae440"
    sha256 cellar: :any,                 monterey:       "c05cf7ab0093d12a8587fd636fe3cc249b0466c2882b6923aa72ec4524b18f02"
    sha256 cellar: :any,                 big_sur:        "5548f2974b63f9bed8ffcdfc02d07e406ee303e0918085377eb7276567f59637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db2ca0a2a8b67f51c6758f05353650aa7b1d0ab02a59f1da3b7240bd4d5f3a56"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
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
