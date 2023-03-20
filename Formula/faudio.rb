class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/23.03.tar.gz"
  sha256 "59489129668ac3134c0483a0fea206db531550f0f5428f99aafec78626054551"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dc9c03562e23ac741b24c85db858c7ed391e7a811f6aa0c786c53bbad35c6e07"
    sha256 cellar: :any,                 arm64_monterey: "a06e5c65e7f189b4a0cc043d1b168b53b27225822954c5088c58e33e5f0a8f6d"
    sha256 cellar: :any,                 arm64_big_sur:  "6b0f424fcc2aeef5e776a5d5eb227933f8eca57056c373543be17b0c058770e1"
    sha256 cellar: :any,                 ventura:        "fac63bb077900d68ae0669cc79878c71d4799e7a41b929c01cb67ddf84f34c0c"
    sha256 cellar: :any,                 monterey:       "9dbe15f334450a49887d6a6006096a4781170debe8a3e753ab83d2c2e340fb8f"
    sha256 cellar: :any,                 big_sur:        "75db7d570c39600299a6f791be0714b60c2f81c4c34e47c0bc2bf9f8beec73cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af9117d2bd5e91213994809b462a17d7a2c9de316f253788c69f671a1eea7c3d"
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
