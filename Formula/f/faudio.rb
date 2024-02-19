class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/24.02.tar.gz"
  sha256 "a7ab24c5aba32eba217505d5c3be25eee691e000b650c437c090f545be4fd668"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fe8a5ba0dc37434855f661696d3de11038f674035e79ea92595049fbd78a182c"
    sha256 cellar: :any,                 arm64_ventura:  "a168f259c58c080925f27ac7c0efd53568812e2b36aaee7f0ead27baf867c80e"
    sha256 cellar: :any,                 arm64_monterey: "a745f24d16cbb034e6563eebd3dbbff631eee9dc0439bed90c1879c7e8aabf29"
    sha256 cellar: :any,                 sonoma:         "73bf4989b1d450f3f674c9fde88e9ec7deebbc40ec3f81d12609c58c8963be57"
    sha256 cellar: :any,                 ventura:        "088c7810c4ac6e7e10019205c93b3b1b9c001aa4094bb62cd45de6a93e9516b1"
    sha256 cellar: :any,                 monterey:       "36c305b0b01bc648e9675c08fd423b3775c4fbe3bfb795e557b6beb74c655ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33f82ff850c9e74ec2c7ad3592400249476bef186238a4afc97f4c46556053a5"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
