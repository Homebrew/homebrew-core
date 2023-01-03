class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/23.01.tar.gz"
  sha256 "763fb3125138181eff1a807ed8b03b3fb921b9b0df30a87e0aa2cfb46c991758"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9826538e3d7e32c034c81d07b2c1b121b0e1d7bcb0c17a60571a82ac4f03ca95"
    sha256 cellar: :any,                 arm64_monterey: "68377f36122c05298a542eecdfee270bac5bd502bf3c80ea6a6ef3eea48013c4"
    sha256 cellar: :any,                 arm64_big_sur:  "97ff89bfece42c102bc638d182d8e88b334e963275b0f514d1a5953c1b91f38d"
    sha256 cellar: :any,                 ventura:        "a507138ee73eab7e3b69f043baa46eca7802f36a9e436dfbc2a9dc5529a268a4"
    sha256 cellar: :any,                 monterey:       "24a5e76eff6647629ada858b36340f7ecc59993cd364ff5269a1ebc5b3eb273c"
    sha256 cellar: :any,                 big_sur:        "6e4bd7743ce1be687c77086554ee195803663a0b81e9c7aa74b7380bf36706bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "706e816a61625cca42d5945e192aaa5aefafe90f6c5cc0d35835e6198af8ceb8"
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
