class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/22.01.tar.gz"
  sha256 "e6b7c0ced90f5a3e1363f95ad990a99afee6784a35320719df48af45d1f07c7d"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f63faf0cd95e4b3c2486e18273b85133af38ceecac71cef348301829fd1a519d"
    sha256 cellar: :any,                 arm64_big_sur:  "86153a9cce18bed2b9bcc3c740787c9e0307057ef0c8c6500c420abd470afb7a"
    sha256 cellar: :any,                 monterey:       "628910651a4599e2b9aaab4a2db8adc30371d12420a0f2ff413118b2debb19d8"
    sha256 cellar: :any,                 big_sur:        "5f80e4f78e04a6750113fda3c1aabeab681998ea803d367060fc460e75a1477f"
    sha256 cellar: :any,                 catalina:       "6f05f5b63129c004dbd1673063b7ae2da591c1ab9f46a0fe006a414c1ea84bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "905cb2ceac1905e8c0198f453a7134a62f9709807face63cf4f3187f93200549"
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
