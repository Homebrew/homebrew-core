class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/22.11.tar.gz"
  sha256 "ba38e6682616e3d6f6b0913be54069020436701af316c9c3479e957c9c1cb758"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4149e72a42c3139656f50aea2b5a8272c07f9e43c910743b353ca70e89f7c9c9"
    sha256 cellar: :any,                 arm64_big_sur:  "10f2129456d5016de962e419d6ce930c09048bd235a9b7703042d07f38b30e2a"
    sha256 cellar: :any,                 monterey:       "2753cdcc24b4ce2d686ae62150ba6cc0b536376d0faca56f65e333ab8a04dac1"
    sha256 cellar: :any,                 big_sur:        "e14460ced8e86b7a72c09eea5efc063096dd3cafd9b54e96695d75757672d12d"
    sha256 cellar: :any,                 catalina:       "f1f1a178689c97849137b00fcbb5614bc3407060c7d4470e70d90f3f066e1077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15bdfbe7ca3cc2e3ff6360e8cf7ab9f9fc993e609cd27a914446ddc4e0e6297a"
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
