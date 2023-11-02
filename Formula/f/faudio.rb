class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/23.11.tar.gz"
  sha256 "dafa0ff6630c19d293e0432babdf04e40e7029ddd87e580c4ff1cecc933f48a5"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b699af9843c798d72d4ecbf1176173f16eea4d0d892063fe9db6e9b2b06bb309"
    sha256 cellar: :any,                 arm64_ventura:  "501f98b7f7120723cec91932da46ffb33984dcb38ef0a61a2ee084be5649b478"
    sha256 cellar: :any,                 arm64_monterey: "1ca7f5a3b3bea63ecb97e5a8db0b9ef28bb7f6f5bd747fa6753ce4cb5a665276"
    sha256 cellar: :any,                 sonoma:         "b718ed1b2a2958a3a0878655efa2ef72a008fce10c154a62234bf4346abf49fb"
    sha256 cellar: :any,                 ventura:        "06756eb6407e61f0ce717b60444e024eda57ea49dbc48919a0cefc8c58f4048d"
    sha256 cellar: :any,                 monterey:       "ac07adab2c6616b8ac964fb572b92a61eeb1f16e38658984050145a7a1fa1230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea0e03a747b0bf05178d782cf7fa08f2125555b7d36ad399008d9b2733fc8390"
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
