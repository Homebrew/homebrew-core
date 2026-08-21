class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/26.08.tar.gz"
  sha256 "5547ac583e2cd1caf0496db62a4c9a813dd6832a2e8b51b1efc00e9492704fce"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bfcd901e1d56e216b9907c94fe764e8e7e172c0ca5eb164a1723fce1a11a18f4"
    sha256 cellar: :any, arm64_sequoia: "d5283787b649fd3fc2e90d053d8305c55f628b360fc65f21d46014aa86f26efa"
    sha256 cellar: :any, arm64_sonoma:  "b501eb4f349acafdbc4f567bddad212638f6815830e3de77fd77fa169698b34f"
    sha256 cellar: :any, sonoma:        "636ffed7a3fba4d65833c98595ba95eb67475238678594d1a528a9187a67f0f4"
    sha256 cellar: :any, arm64_linux:   "9f1bb9aa2cb109385a3ea71a4539f39b8a148a031b50367a299d59fe9b51aa4b"
    sha256 cellar: :any, x86_64_linux:  "d55217d34d997fbe2db650bfccf471522fdbfb06cfb023fd6a10f3758ff49cd1"
  end

  depends_on "cmake" => :build
  depends_on "sdl3"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <FAudio.h>
      int main(int argc, char const *argv[])
      {
        FAudio *audio;
        return FAudioCreate(&audio, 0, FAUDIO_DEFAULT_PROCESSOR);
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lFAudio", "-o", "test"
    system "./test"
  end
end
