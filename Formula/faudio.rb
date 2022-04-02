class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/22.04.tar.gz"
  sha256 "ee1b9b329d17ba65bf48d90aecca27e3226983d3807dec04dcad7e6d4922f4ab"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "06db316db47dd2e0521262b5523541a5d9441a0069c3bdd7f02ce53e3ffe96e4"
    sha256 cellar: :any,                 arm64_big_sur:  "7648a699685f8da8d468915a8d4e8851c6c0bb1b90128c9d1360014fe30b054d"
    sha256 cellar: :any,                 monterey:       "e282aeb2e783230795ea429d5e59a820fece98e6903de68500d722417534fc51"
    sha256 cellar: :any,                 big_sur:        "11113206b52d16223e5daf9af46259ec9132aa0abc032978b1fcdcb372522856"
    sha256 cellar: :any,                 catalina:       "e3f4ad211697c73a4532fd185ce11aef1433aa861abfe8209f9f52000cb4e034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "272fcf5ca048e39b2de4b7f0fc5d098206853ad04f3e107e92ccb5bb5ae30093"
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
