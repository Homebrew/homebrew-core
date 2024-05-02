class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/24.05.tar.gz"
  sha256 "9c5eb554a83325cb7b99bcffc02662c681b681679a11b78c66c21f1e1044beeb"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "648e15e5fe69cd260e464183181ed5ba9e823c9114bb0e09c5f352dc7c0fe427"
    sha256 cellar: :any,                 arm64_ventura:  "dc823040b6dbfc2c3cece32ab0530b9e5d3c2857c7bd5eccd6954ebdc5ceb675"
    sha256 cellar: :any,                 arm64_monterey: "cfbc1e89ebabb928af4edeab8d58dc9fb350f810c562baee201a1f9564a34d37"
    sha256 cellar: :any,                 sonoma:         "90e664d32e1f63d563d23c491a2fe4049b5bca3cc1112ddde397912b67d90510"
    sha256 cellar: :any,                 ventura:        "66062ca3a49e6c7224d975eca140ceceab57e3d6d5fb2cc9a705856b5298c2c9"
    sha256 cellar: :any,                 monterey:       "9e3b44e41d91339fcc66f63b5ac21b695ba33509fa66c0b7012f38a9171caab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1a2eeda9f10eab37d7a09772c3ccb0ff0a449b375938bc147ceb21c8bdebd3d"
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
