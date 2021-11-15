class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/21.11.tar.gz"
  sha256 "1389100ca132e06455ad7e4e765a045d9821c234f6e388bef6a0c8d610ce36d1"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "165546ec6d631b3e81092c7b93432056abf52e34d2707949cd9b38f020e28eee"
    sha256 cellar: :any,                 arm64_big_sur:  "5c1bc945e51747f1949f8b7161a2a556af7ddb588d630b412d6e9e2b3301e0ba"
    sha256 cellar: :any,                 monterey:       "21287edda6dfb42f3b94b083587fd9f6440b3845aafba6a5c28762c63082c0f6"
    sha256 cellar: :any,                 big_sur:        "7fb00aae4df2e89331b2dda02d3a6ebe40c5bfe35a853617b53f3e1a93619c00"
    sha256 cellar: :any,                 catalina:       "b0541219a2cde1b99dd4b43dc211ccdac04400e488cfa25cfc7695afe6af9768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc8da687c52037b7ac389f6f0576b5171c0f45ba8af1e91360688a6c7213d20c"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      FAudio is built without FFmpeg support for decoding xWMA resources.
    EOS
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
