class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/22.02.tar.gz"
  sha256 "fc6248fd471c59dc9dc1de706a186064511de666c78a7358861d275c084df9ed"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e0bb9195b9c4bbd8fdd559b9c1fd1b03e3ceacf39b1092cdcfe55ed31381e9ca"
    sha256 cellar: :any,                 arm64_big_sur:  "a362750f126c8377d4da980260e31c8dbbaf0ee20e08f31f7161ceb0bf08898c"
    sha256 cellar: :any,                 monterey:       "085c4271d5c25762c479492b762eb63825834b6c71ef602696efb9871f7760b7"
    sha256 cellar: :any,                 big_sur:        "6a57e1f9bac80a4a3a5060d4af15caae43d0e602536af15d712e321490bcdda9"
    sha256 cellar: :any,                 catalina:       "493e4f6c2d40be26636274bd2600daef24756813b2d145e0124149dd23be51a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "046a13dd4a6f6bd01d05590bd1815e136e9e20d225a6c239d1ad383327be7587"
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
