class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/23.09.tar.gz"
  sha256 "9122dfecffeb8e420b02eb25264aaab4151ec923de3a8fc8a6fc91129a3b6fc1"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f69ce8a41fbea768921b8eaad6c625e90302d87a942d1d0b0e83abcbb496ffbe"
    sha256 cellar: :any,                 arm64_ventura:  "ecf7c6541b2a7c8e66945bde4c3c0ab038f98c7ebe864d23261ff1a1a8e51069"
    sha256 cellar: :any,                 arm64_monterey: "b85316dd2fccdec714f943e1b07de541628f374935981c19cea7d385c739a88d"
    sha256 cellar: :any,                 arm64_big_sur:  "020c7f7859719a3ee3444bacc017c765581c966fdcc273c04698a340ad72c7ee"
    sha256 cellar: :any,                 sonoma:         "8ca16914b4c23f84e5b92d04b6d003352379003355331dbf47405ff6716b7751"
    sha256 cellar: :any,                 ventura:        "e224231eec8a42ee0aa7e77b968d5f04c78e2e6fbc332b0c1bb49cd92a91c6ab"
    sha256 cellar: :any,                 monterey:       "bcb6bdff6df0934fb23aaa0ba4d94ea72af574a3f1bf1c75dda1b5bf6079902f"
    sha256 cellar: :any,                 big_sur:        "3fa7cefe1f842314509887c684ded6a8b5351ff1e716cd7b6fb282085292f2d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b21b64fe1d0b962aaa3e991734f27b44755a2c03a7e5fe3fdd0d28498b639e44"
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
