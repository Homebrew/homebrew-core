class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/26.01.tar.gz"
  sha256 "6b4cf0e145865ade8951980d5f1c8db5b203d64020ef120817cdc96657d21a6c"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f4c0537f26e732f4c5b0d9611569352414c0397fb6f31f7874c3535075068f6"
    sha256 cellar: :any,                 arm64_sequoia: "bd27ad817368506582f49dfab88b9b9d33783a9a2683a0c06c5c301f0fb52fe7"
    sha256 cellar: :any,                 arm64_sonoma:  "d9bb9c63501786dd36278c67cfa7482ab3e9513b522326ba1d9d3b7e3f5c73e6"
    sha256 cellar: :any,                 sonoma:        "3343b89a486613409ab5594698626763b81cecfe5de9368178b5daea98c33f34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad3e26b8072b42431d7eaecfac484b82f3c1d476229c822e691ca1fd04bd6956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e82353c854a735bd8f8ca48f5dfa451e02b32913c30617324c05b742dcb08e0"
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
