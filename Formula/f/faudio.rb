class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/26.06.tar.gz"
  sha256 "f58d6777f90a3650b16ee78b3b5ad65c1c0f2d6e59ef54aa62b20939efbb945e"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b3fa49ffed9a67984260b9bb4667a2acff9576274b7d48c17187873a43390af8"
    sha256 cellar: :any, arm64_sequoia: "94b591d4c2217147d712bdbb58e552e85da2bc9f7cf069876ae6a8d83b3f8f40"
    sha256 cellar: :any, arm64_sonoma:  "6de87ca8d49cd0b997d637365ee3af891e21c7b45257e8827c215e10fa35ea5b"
    sha256 cellar: :any, sonoma:        "b52c86b2490d50d81ef5cce3868eb0e2d65b19e0cd635c40d4e6479d0644f097"
    sha256 cellar: :any, arm64_linux:   "d6ca84d622730abb779f0dc862970baf03266095c1e2f001084f1cfb1882b18f"
    sha256 cellar: :any, x86_64_linux:  "d54c86e7bd77110abf0cb4c5b35008564b8a4b9a8eafc588197dcd284a19d50a"
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
