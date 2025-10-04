class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/25.10.tar.gz"
  sha256 "ca00bc7be82eeb975385ac490709817b662b6c148cb384242061d3a152131bde"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "08358575039a8e73cbe5a6292cb24498f823898295a732a24de0dfa51ebda2fb"
    sha256 cellar: :any,                 arm64_sequoia: "596aed33dfe06a04b279331665573b28a411f3c4abf69ef422e693ef2cfbe98a"
    sha256 cellar: :any,                 arm64_sonoma:  "0611a3d0dd588ec8acbc3101936427da5f72eb3f33b1f0f5764d3b26edad1dff"
    sha256 cellar: :any,                 sonoma:        "bb72a3602879826eb4fcf1673bb33294895affcb81a84637a61362108cdb47ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a277e463db441e046ebc23a5526b7f4fc9b837c87a1496e03f8dd1fdf5a9250b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee3ff6a1988805d67bfd1b3a119f311bdfb62c3306a8338252cce8ec99e70bb5"
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
