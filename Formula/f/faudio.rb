class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/26.04.tar.gz"
  sha256 "d5030cff133ababe33bbc036a21ae5de911f8928ba81bde3d6c2395d62bb8096"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "90b4e8a6747ee1ab1eb66d1a92f6ebe147d78d9e74be5636acdd2201145bf034"
    sha256 cellar: :any,                 arm64_sequoia: "457de6e73ec7baad5ceeb1f588748e7bbae3ae30f1456c98241c638c4ab59c2c"
    sha256 cellar: :any,                 arm64_sonoma:  "3afacbb4c458339f59b476bfe60e0afb674062ad9aba748544024918dbd91094"
    sha256 cellar: :any,                 sonoma:        "97ada89348928eca68be6d46d10476918b460e404a1e4ab5ec307c64d338a386"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b93314d94d0dab5829523734fefcdc483b9cbf1cae2d600a77c706eb63787e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ec935b67a75f04159dfe703305657ad4831b2d8aecac85da3d312b35378e709"
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
