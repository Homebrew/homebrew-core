class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/24.06.tar.gz"
  sha256 "62a6d0e6254031e7a9f485afe4ad5fe35f86eafbf232f37d64ffc618bb89f703"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9aa448f552bed84cc5ded5a8ced06572d173c553e9c2df8e16bb802d675e4ecd"
    sha256 cellar: :any,                 arm64_ventura:  "a347debc3c5c5ac39217f375c084cc8c29401ca0edeb275d32dc66c527aedaad"
    sha256 cellar: :any,                 arm64_monterey: "013e1a3559b99d8d23cbe00ad70e424ed9bec4a44a2d0a1d798083e0c15e8073"
    sha256 cellar: :any,                 sonoma:         "9584c77d39afb6df8830761a6248cef03dc8612df1a41d9b7d0e2891ef884980"
    sha256 cellar: :any,                 ventura:        "42d69ba9f1fd198e13f04239a65c72765363ef3541ac7f0fe70e713bc68b2a15"
    sha256 cellar: :any,                 monterey:       "b9f532bd38875d18a535772d2cfe7b9445b4da7e72f24768d473ebeb2968c87d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ea1d44b2a772f297a774afb60ce44520529665aa55fd6426ff81056e9b878ff"
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
