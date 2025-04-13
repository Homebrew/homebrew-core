class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/25.04.tar.gz"
  sha256 "9f7a7beb1e9b7785e4de6ccefd10603f05076a3610e0764e964863cf2f09efd4"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ed3203707e66ecbdfa3baf5a3ea6c73bcf092a9c2729c68284bd829e2ef03dff"
    sha256 cellar: :any,                 arm64_sonoma:  "9278abafe9c426e2af18eb39ffcb7811b256de3056f501018117bd11d5b7493e"
    sha256 cellar: :any,                 arm64_ventura: "bc2c824dca3cd3b6f50564c95bc3d9b9fb9c16abad92239f921d9b94df46a3e0"
    sha256 cellar: :any,                 sonoma:        "2067ab657abe01ab80b6486aa064a6b3db368c5a777b327665d108ba1548d739"
    sha256 cellar: :any,                 ventura:       "0acb99d005ac13d3330029582eb626666c152dc7869faa366eb3f8933cd5a5df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "609fb6629b685acaf45ac13f24a165424a85ed6e226be393d43b4eb25005e37d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "366a7e20a8e46852d416a00d33d4ee89a9b2b9e20fcbe40a04ce7e1f42d42c18"
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
