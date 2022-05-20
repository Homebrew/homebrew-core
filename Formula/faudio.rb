class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/22.05.tar.gz"
  sha256 "d1e68f6cf4413aafc027c485796e9162ae5fb0df29bbf1cdb31ac7861b67f72a"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "56d483f0b97246e8c207c4440e2bdaf5e93a6a3c51c15802d50040ce95ab11e8"
    sha256 cellar: :any,                 arm64_big_sur:  "b04fd450e6c78234d0f492b442c70099c7d8544e7be97d9a1cd793302852f731"
    sha256 cellar: :any,                 monterey:       "34e560a4bd19303bb55c70c81d2f6d975e40c1aa38a1dad1335b896fcc53410b"
    sha256 cellar: :any,                 big_sur:        "0aa18a2af5818382ce6999d6eba103a3cedabdd47d475bd7b99479c51de47800"
    sha256 cellar: :any,                 catalina:       "e651be8cfc29db33f34617a6544e6421cbd7a7bb9e64bad1f122105afbb62bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff972204d9070d9835ac2d1e504ad267c86212ba4583e871988889c2bcee8eb0"
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
