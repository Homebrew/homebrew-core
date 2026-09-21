class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/26.09.tar.gz"
  sha256 "b393b2f90b21e9160fedfd3d0da88c6c449df38c17699790b1df1abbf5751792"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "291fdd4d98a89c79aa7c1bd2efdca7eda4207af9b5d4c29beb67d5a4052de40b"
    sha256 cellar: :any, arm64_tahoe:       "075871cac458afca889436220d3d992698a017b0015f88925b365de895595ade"
    sha256 cellar: :any, arm64_sequoia:     "8449333647cfb4be4c81066d15cac1d3d63cba91f4b686f8887eb335e7f8bf61"
    sha256 cellar: :any, arm64_sonoma:      "cc6a84a669e7db5a524b1fd19c27a6031a194142bf8bfcfcc815aebfb5d37f9b"
    sha256 cellar: :any, arm64_linux:       "8856f17cbf870e34539ac5aa2e422f6cf2256611739e03c48a877466ab85485f"
    sha256 cellar: :any, x86_64_linux:      "da4a9504501cadd75d8cab9dd5927981b3663d56f701b46ee8a87b8cf87b4e5e"
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
