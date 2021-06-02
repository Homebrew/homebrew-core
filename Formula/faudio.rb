class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/21.06.tar.gz"
  sha256 "7385980a6a80529f240e3731ece4f66f38919a2a0cba799d608eb2ee08e10335"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9a40ca444a5f92b57bfa6b1ddcfda9db37ca3eb2e78faa4f744c9df5d40fb2b0"
    sha256 cellar: :any, big_sur:       "e81a90cfb9f516873b94e3f2b9627749db8457912fe448893479da5314ebfc90"
    sha256 cellar: :any, catalina:      "daee0632b1ff0c944ba76ac363d08679014739028f7d20f6bf21979a7401ff10"
    sha256 cellar: :any, mojave:        "2ba7e51c05eb94d17bbb57aad8f82ec9b255ccadd1c07b0fad5c95040c82cad2"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
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
    system ENV.cc, "test.c", "-L#{lib}", "-lfaudio", "-o", "test"
    system "./test"
  end
end
