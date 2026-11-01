class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/26.11.tar.gz"
  sha256 "8fcd197678ad1ab5c95f0901c3770d8d76c1d8b1da819f6873db599807ad7d03"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f08effd033d40866f3df01e75538cca22c1d57d94c57a31e72a30eac61e728fd"
    sha256 cellar: :any, arm64_tahoe:       "de9d2872d272adfdf3e14777c66286025c2038ea3b401b4a153907110b36d4ed"
    sha256 cellar: :any, arm64_sequoia:     "d33b06b63c55a4e3f1c56e26f78d9ebd50edbe74e5926c7b83fc19f906c8a4b2"
    sha256 cellar: :any, arm64_linux:       "1b2757c5864799bda70dc24fb58f6a94a66c93acc6473f65abf29b2ea9bbd077"
    sha256 cellar: :any, x86_64_linux:      "116c011ebf1558e32791aabaeeb43e118acc16cbb8e600abeaddd273df939fdb"
  end

  depends_on "cmake" => :build
  depends_on "sdl3"

  deny_network_access!

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
