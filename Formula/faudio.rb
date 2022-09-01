class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/22.09.tar.gz"
  sha256 "b7833a0d095bef68cf5c56418e216e96f0f33452ef7d73cb8a4e37a54a74d977"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bc2485eb6817714643f190d77ba28e6802a7cbf8ad67ee075a539b66ea40e10d"
    sha256 cellar: :any,                 arm64_big_sur:  "2302caff4ae43f356ae8faf95b30035e9e251cbff58b612cbf48ae29b942c910"
    sha256 cellar: :any,                 monterey:       "729994576918cd9fed78c4945c931b39f5d9241bb4297d5a2c5d5d2242dec50b"
    sha256 cellar: :any,                 big_sur:        "9d399223ecbbed1eb75f8d51b9b2efcbb792101d8424d4c700897cbfdd3f31a2"
    sha256 cellar: :any,                 catalina:       "ade36ad5c0a21e79e4d890e2ff623aa87cb006cc70554effcc4194a921b3bc71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e03dc7c8e8094e84cb19af58dcb479d008261e7464fcce48003198877a3541c"
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
