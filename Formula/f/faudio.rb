class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/25.06.tar.gz"
  sha256 "34e587c567cc947c5f4f485cfbe5c9ff747d50d4e17b2d86a9f190d411456232"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9d8c40b0d26c3d7ba683d116a08574418b28473af1478a7886c6579be324d8a0"
    sha256 cellar: :any,                 arm64_sonoma:  "0dfdf36779f9a2e87e7ada070fa41726627e70cd3cdc95588a1ff8d58f14d211"
    sha256 cellar: :any,                 arm64_ventura: "9d1c610eefe6394fe54532612fae37e100e57542fe4d40b6be5217a40f6c63bc"
    sha256 cellar: :any,                 sonoma:        "75e6d99d9918182c9e2e8cea2850bfa537635c342191c6855791e9828c2cf4a1"
    sha256 cellar: :any,                 ventura:       "e10a6ac474bc6f136ffa503c78c211f12f8a4ced604343ccb8ded8c3da5779f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "156eeca0a2ed4d6bcc6b0634a81ed0dc944f8a26270ad346120bcb9f501627ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb954490b9e4b1ad18af7d6521be1605d84a9457e070e7dc3d213a6768ea2267"
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
