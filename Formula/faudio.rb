class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/19.04.tar.gz"
  sha256 "8d28c7a67bf67953c27173f33393ccee10f7b3ad52b9767a7e33c98387b67bdf"
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
