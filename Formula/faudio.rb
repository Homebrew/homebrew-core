class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/21.09.tar.gz"
  sha256 "8888f075594c9c0e9a83fda9b4556a5d290fa02ed0ba7cd35ecfeb7c4d7968ba"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "bbb0fad92eae018ce0e93eb7c7554dc3b3a443efc64729cc58dcb62b86cc6af4"
    sha256 cellar: :any,                 big_sur:       "f6e39fef453733dd5d08f2b3dd2d7f1fa62dbdd294881fdc8b827ec8068d2e13"
    sha256 cellar: :any,                 catalina:      "001c58dd8ffb62ac8b7d05b188b8fa6bbdd52689e64750bc844ecd3be486dfee"
    sha256 cellar: :any,                 mojave:        "cb21fbb4a94202d5738c3149cadad32d357006fdcd216406b724d43f629ec972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abc23b7441edbe2882d60577de8a2179901c1806ac5a01f14d550fa49a1c12d6"
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
