class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/24.03.tar.gz"
  sha256 "1207d68e1459679ac4771fd41d9ef59a8d5442986ce8dcdf36db92f5f22cca21"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c6d0b79dff51e3847f67c745bd9786d0693d654255d684dc552448da3d650c33"
    sha256 cellar: :any,                 arm64_ventura:  "83226f687f61ba2e2bc7e32858ef2ba124d6d01c585ce0712fb1dc73b6c26852"
    sha256 cellar: :any,                 arm64_monterey: "e047a6cb7fa41cd960d97db81c620bb9e5317afed5a134c77bae299d1fd7f470"
    sha256 cellar: :any,                 sonoma:         "d759ec82b4250e688978a9ad76a73f135db12ed255709af8dc1e2d52479df238"
    sha256 cellar: :any,                 ventura:        "7b5a0cdf8c90c1776813501e3b8c08d52add377b8a2246162040d8485f1f08f1"
    sha256 cellar: :any,                 monterey:       "2c12ac08a01f3adb4cfdd789ea11491ed5da1df8557ec6b5570d314f59ff2203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "973ce9f9f872325870b4c76cf4b47817dfe9699f9c46bc3c782b3e1c78b77bfa"
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
