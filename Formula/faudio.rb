class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/22.10.tar.gz"
  sha256 "c2b3d52cb4a649582f4c10f3fd8245985b305b16f6c46dd191cb296a71f9250a"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "08daf37d124cabebb3f7072bc5d5f1ed13d0a39ddc79f4faf6ab5c9c8d3835cf"
    sha256 cellar: :any,                 arm64_big_sur:  "3c9d4d22b1cd6e097a0af35d8cd99d4ee052245e2542dab1770bf9630e5c9f34"
    sha256 cellar: :any,                 monterey:       "ade5bf3d8e61519e2ddca5d637356773b57aed450d4877d0dfa52d6a37b182d2"
    sha256 cellar: :any,                 big_sur:        "8dc1c741b7d0611b5373a11cebcf0a8665045c04921939b1224c2a32d8064748"
    sha256 cellar: :any,                 catalina:       "a79a258b51d2b5cbc86542d244e9c868d173fbaed2ec974074e4cb698aaca479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e71acfdeed59a461bb2bbeec826007ae705cab6c7f7a86a1f21403fccdd48c6"
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
