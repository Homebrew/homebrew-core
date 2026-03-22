class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/26.03.tar.gz"
  sha256 "6c3177a3551dfc1fd8f46c77a5ff690e811eb98e321c8c79a3a7790cee0bb990"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "23ba68578cc293565bd3dd7392b3fb1a24f121ed5476fb7908c94cf550ca2cb8"
    sha256 cellar: :any,                 arm64_sequoia: "44f22b514a7fef5afd4db5108654d6711f9b0db1e1ba368cfc4a57de43963444"
    sha256 cellar: :any,                 arm64_sonoma:  "79dbf37e4b500f79193d9ac413301550fd133dc37f162f4ac89b5193829f8891"
    sha256 cellar: :any,                 sonoma:        "25ff1129eb87864bda0d409e01fa17e47d8ffdb1c25ba68e444de6439616a525"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "822282f28c28f0ead746e11da0cbf45398df43ac57c9b48095184da23d658f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "befde7ca209c872a77757d128fa52d3ebcc1dfa3dcd5b9615116d8b4d4e90d70"
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
