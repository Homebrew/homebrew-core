class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/23.06.tar.gz"
  sha256 "52f3c0703cc3b3afbd745b150860287799cdf457dcc90bb5ab937afc8b1287a8"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "531d8928f32962cdb056672ed17cecc807825c0ea5e72b57f7a777d313d79b95"
    sha256 cellar: :any,                 arm64_monterey: "9f3e089f94abce63c9b6693e5db945fea727a3f574e0afdc611248ceedb7c9a8"
    sha256 cellar: :any,                 arm64_big_sur:  "5f76930e167f646e0e09c924c0f5daa0d32cdb2a752134e5883e5af239c61cf9"
    sha256 cellar: :any,                 ventura:        "77bbd7844c04a06de1e6dd2d3489548d1d53cd6ebb0a2bfc071e0fc113293617"
    sha256 cellar: :any,                 monterey:       "07a9dd38c120de99e91e25e74ce37a9d75c0c717b1d5f5806f86f5b957ead02e"
    sha256 cellar: :any,                 big_sur:        "f2ce7d903035e603e64d8da9c2279407e480a08242db064a7c12214b464f5627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "916a59c0ee503d486f5feed02362010247c99011e8734ad4ab8b2833f87cef59"
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
