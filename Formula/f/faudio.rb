class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/25.01.tar.gz"
  sha256 "044a79222ac01eb0e279f0204e403f01dfea03d29163a721ec266135dd09fb95"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "878cad02164b5cb077145195a6bbe08446b4296edb7774a7bd454655880332fe"
    sha256 cellar: :any,                 arm64_sonoma:  "24028f4449b2f9ed15774dbe25fff96209a372d638d4107ec5b8b444329f2939"
    sha256 cellar: :any,                 arm64_ventura: "5573b9a5fcfc5889b0a24a6a8cad7a1e69be40856ed2726d3f61902527961166"
    sha256 cellar: :any,                 sonoma:        "8c2275c45672725ef981cb5676778a3d38f0de1ee2f3a3f47dd4038e5466be4e"
    sha256 cellar: :any,                 ventura:       "8388fe308cb670d97b287bb9a80d4455c23552c19236d9839c5e80809aae14b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b1270da232ca4c686d816d93af7046afc0bc38921c72224bb2a8d16b2c81dcc"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

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
