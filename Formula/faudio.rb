class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/22.11.tar.gz"
  sha256 "ba38e6682616e3d6f6b0913be54069020436701af316c9c3479e957c9c1cb758"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8f2994912d68a940a42aeaad11fa32e49de6817ef1a4bf20407c0fee26fd595d"
    sha256 cellar: :any,                 arm64_monterey: "b52eb6df5abfdf447d1c53469a4f85fdbef698cdaff021255cf320b4d98e6cd9"
    sha256 cellar: :any,                 arm64_big_sur:  "f1f392bb64d544bc808a8a9ec40bc334665c1b6f98b23e65c493ebf591c9813d"
    sha256 cellar: :any,                 ventura:        "2adabbe5546108367be0588a02096a2a5b8c3dd73f1b3508d11cc0de41f8e595"
    sha256 cellar: :any,                 monterey:       "0a36f116ae330fbbf69884c3c8eef5faa367565790f9ebc2ec67138f7cbfb07a"
    sha256 cellar: :any,                 big_sur:        "9a7a183085d19b334695f66cd57188f1393ecc306c5a82877933af37d62c536e"
    sha256 cellar: :any,                 catalina:       "e6ba2525363b866ec383cb7913b2552f76a19520545c895154ed15d30f966697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dafbb727aab16534dce8f5f40944cdc370a44060b9461ff383016c1e9c72b3cf"
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
