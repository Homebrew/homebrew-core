class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/22.04.tar.gz"
  sha256 "ee1b9b329d17ba65bf48d90aecca27e3226983d3807dec04dcad7e6d4922f4ab"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9ca2f4d7c792961c82e23c56a6ac16ed14ce61c91510632bd32b8cff8f368cd0"
    sha256 cellar: :any,                 arm64_big_sur:  "64f5f3737235f5496d554d70901c6283c05ee90aeae596da1b07263e39854b1c"
    sha256 cellar: :any,                 monterey:       "7b3dc5dc9d4e191bb49ac5f0357f0ab9b397c529e3b8f9f65ce1eeeeb1f3cb61"
    sha256 cellar: :any,                 big_sur:        "ddea2ed3048f8f81d29698af20de4f0e02ecea0b6a7f26763dd6d73f43000a81"
    sha256 cellar: :any,                 catalina:       "ca0b7e71fb296a5c29f257669752b5088888c5aea8292c7cadaa3a9a2e6883ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d0431a5c0b7f568c84cad8c8f985c974cf190335ec62fb53ff98dbf727ca0ad"
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
