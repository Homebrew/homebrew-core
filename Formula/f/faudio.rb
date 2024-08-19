class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/24.08.tar.gz"
  sha256 "7c116d79d24abbca192e63de2d7ee42a679e1994f0a2e79200731b9878fdacca"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "38eca2183d92a3c2ed49a79078c52d6b782a4fab66402b72b1a7f4c1b7206f62"
    sha256 cellar: :any,                 arm64_ventura:  "574444729fbaafc898ab1194cc11d12fc5d4069dcdc6ccb1788588c122deefb3"
    sha256 cellar: :any,                 arm64_monterey: "815c70f7e00cc237ea3e654eb3cc0348d1d07b19a5891f294cd027317c43a7fe"
    sha256 cellar: :any,                 sonoma:         "c9b012a3055588010ede29477933bc432eec5b58f28e89a4738c9b368d9b52ae"
    sha256 cellar: :any,                 ventura:        "2be4bcfaa284691cf255276f10006f9531f80a3f7ae7fd447475e7ef9aad70f3"
    sha256 cellar: :any,                 monterey:       "919c2a6d58fb5125ec0911b4d964cc4baa1d9f404d4b09df059ffa74bae02a3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d8a0bbd905ade119bc3903f497ceb64eeac568f41e98c3b4be52801642012a5"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
