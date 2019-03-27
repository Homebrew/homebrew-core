class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/19.03.tar.gz"
  sha256 "5ab1c2b00e0348264bd959e437d590d6240d2527964d7c5ee0d02b711e089fa8"
  head "https://github.com/FNA-XNA/FAudio.git"

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_TESTS=1"
    system "make", "install"
    mkdir_p prefix/"tests"
    mv "faudio_tests", prefix/"tests/faudio_tests"
  end

  test do
    system prefix/"tests/faudio_tests"
  end
end
