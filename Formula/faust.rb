class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.41.1/faust-2.41.1.tar.gz"
  sha256 "72145e1d4ffcdd8e687ed7960d1d0717fa2c1dd2566e0bbc3a78fa95bb8b683e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5c600c392f411bef5e594fc049fc2e900af6793f575c775d7b59fce8263b7809"
    sha256 cellar: :any,                 arm64_big_sur:  "bcd8e1b348b25fd5d86a958d4318f6fa85cb833dbe070ca624351545b431f367"
    sha256 cellar: :any,                 monterey:       "7e0ab1a5d14045a88dcf9e94732b71947e2edb3c008594e9b5bf505907354322"
    sha256 cellar: :any,                 big_sur:        "f43967cc5667cc7d6f0fd32b8c061aced93eed49b65c5350d7ab9b3be9f27833"
    sha256 cellar: :any,                 catalina:       "2fdb52829b14fb18ae8050dd595bf93841b98b82bdd40a61146f11bdc4d4021c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc27866b889915dc0e345a0e86a637bc8ef4f3e6f270269ee2f770372cbef5e3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    ENV.delete "TMP" # don't override Makefile variable
    system "make", "world"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"noise.dsp").write <<~EOS
      import("stdfaust.lib");
      process = no.noise;
    EOS

    system "#{bin}/faust", "noise.dsp"
  end
end
