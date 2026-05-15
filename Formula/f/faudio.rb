class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/26.05.tar.gz"
  sha256 "09390c33c8eac6487b10c6d3fa3ea26591ccdb0d57a2a4d465e0273bef028576"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a8edeb3816b6a927eda56916867c9a82fedc635525fd2bf79d82fe40a40f44f"
    sha256 cellar: :any,                 arm64_sequoia: "772c24c2cd0d23259af52728bd0f3db9f7adf5d1b32b5dd45de671d289aee183"
    sha256 cellar: :any,                 arm64_sonoma:  "1ae958f893a4e9ca6ff0de67b08cd5999dc3bdfb59adbe4b8ee56f47b4aa37a8"
    sha256 cellar: :any,                 sonoma:        "929f9abe720981be2519419b5936da1fb0c29774d7f73d6d649cf348f0cb2922"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c193bf4d588701a77a4a13be1419a8237107fc9a94d1298bc7ad5dc174915eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c3a67c6f613932390d1dc79c51c26bb6577eaee6faf0b6ae1d418c96bee2e14"
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
