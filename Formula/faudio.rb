class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/23.01.tar.gz"
  sha256 "763fb3125138181eff1a807ed8b03b3fb921b9b0df30a87e0aa2cfb46c991758"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0cc16b787347d852148a4c827d80eb2acf8c6f43ff080b63d705f0782d642ff8"
    sha256 cellar: :any,                 arm64_monterey: "4be7c775a5ca9b5c7a54951e82413ff222f69571a64ee390f585f68673ef18ae"
    sha256 cellar: :any,                 arm64_big_sur:  "095abfcb153f4dc0167b2029fa7a071062e44c4e980e9962457dcdcb7c3af32e"
    sha256 cellar: :any,                 ventura:        "4b27630b1b4d4ec3e90beff0909d04c8b9f5b5f854601b273e605478b63bb01e"
    sha256 cellar: :any,                 monterey:       "f3fbbb767d9ede01bc4062844a186c8a2034b76449c5e939fb1c57b2b09b0ea0"
    sha256 cellar: :any,                 big_sur:        "11c4c4fa43fc3d0225eb083b6d4c0d8129d9d978521c69eb4d9d5313b8dfa8ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e42b3afbe424082966862e24a49690a55f11d3b2fbffe6e69361dc255885847"
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
