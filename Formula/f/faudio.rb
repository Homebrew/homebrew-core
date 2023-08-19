class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/23.08.tar.gz"
  sha256 "bf73c20a2082338fe0b3c283fdb3de08b5f2802bfaea8acc59c70c05567e94af"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7909bd61a139e77c946d8d3919ac09ed1e35e82f57b3159ae0cbdb30a3c0a99b"
    sha256 cellar: :any,                 arm64_monterey: "960daea3145afd085d715815435c5a333aeb39dd77de4ae50676a9bb3b717a82"
    sha256 cellar: :any,                 arm64_big_sur:  "b3dfc29ee3736cccca56e1e615a7c4c6c626f912a4095354e3674420c63f4ef1"
    sha256 cellar: :any,                 ventura:        "cecd00c5849de7f369eff7d9aad9d26c16f6654b679054caeb0539500d2b48c3"
    sha256 cellar: :any,                 monterey:       "66d4b9b062e6f71deb030912604c26d56afc14bcc2363aeee58dcca361868fee"
    sha256 cellar: :any,                 big_sur:        "6d94f3fa9d728ccef942e64c7261811e9d5bd2cf8918ffb95fed3736fea194d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "912740fe445bd2d8aa012f158364347315ddd2515d487b1f6eac1693f62363de"
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
