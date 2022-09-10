class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.41.1/faust-2.41.1.tar.gz"
  sha256 "72145e1d4ffcdd8e687ed7960d1d0717fa2c1dd2566e0bbc3a78fa95bb8b683e"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fc477fdc2e3c3a3348f3df4365d0e7c4dbec8696368e5d71c910d4bb1f2dc112"
    sha256 cellar: :any,                 arm64_big_sur:  "58eb9f637145e6ba29ecb77b0b0ea7b31d90a8ef9b33be7fd63d179aa330d988"
    sha256 cellar: :any,                 monterey:       "ad3bbbcdbf1338dcb675db1e9c213fe04d95fb121b7ec79d1cf97602b322bb65"
    sha256 cellar: :any,                 big_sur:        "acfb0922b00d37fb2d665aa8f7690fb0744b693369481cc188a5a13cc519af97"
    sha256 cellar: :any,                 catalina:       "fc933193d738f6dca2a8e8c795665798b40f8f643016d7c08768c77b15b98cb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c74dd24abdf631a87c512eb3e2f291dc47927717148a3c9d2158fdabba71c5f0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm"

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
