class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/23.04.tar.gz"
  sha256 "8e0bbf107103aa5f7d05710cdb27d66551a5dd18d78a41f2da79b58dc09361f2"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9eb1a2e18dd88dc440c8eac2148766896cd4b2b6e9f61d3b37abf3aadb3ea3c7"
    sha256 cellar: :any,                 arm64_monterey: "839c50da659ee156c7e594b692ca7808d70a660e22ef5a25cc7489012d23dc49"
    sha256 cellar: :any,                 arm64_big_sur:  "01711f0766fcfc7a19267f8ab49f60a578a0189c7d34b687357ab903c83662da"
    sha256 cellar: :any,                 ventura:        "dd6e00a5ee1d852089b8f3ea65e9bb909df42e83deadd9cb9e01324ec22e06b2"
    sha256 cellar: :any,                 monterey:       "32f301284e1e2fe1039fa418e56dbe8d381367791aa0e7be3f85d13edb57973b"
    sha256 cellar: :any,                 big_sur:        "d7fdcd57cee7c59ae47cb5f79c617a89e4f585c31aa080e9e7003d962d223573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "825da3478d777cb546efabfa3e7ea248206bcf89e3bfdc2dae1259e50f5e390d"
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
