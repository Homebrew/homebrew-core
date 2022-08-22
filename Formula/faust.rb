class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.41.1/faust-2.41.1.tar.gz"
  sha256 "72145e1d4ffcdd8e687ed7960d1d0717fa2c1dd2566e0bbc3a78fa95bb8b683e"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "17aa5ee61ab5a17820f9d045befcab14088af6ca1d82bea63e35dbd0fa1bcfed"
    sha256 cellar: :any,                 arm64_big_sur:  "293bd3661ab6545abe556f885aeeb1f7e53b7247c69c75199f2daddb85e13931"
    sha256 cellar: :any,                 monterey:       "0bec0f9ffbae2ed013c886206b304319f13feeecee1ee635a9522dc8dade4392"
    sha256 cellar: :any,                 big_sur:        "b2d4cef298a84daca5e4bdf177b82d3a11929ecb8593cd91142f6fe24621a1d6"
    sha256 cellar: :any,                 catalina:       "51b723b1dbfb00049af0206a4e0a22314806cc9baa806ca66db2aecece3f9be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30db81472a7bd423fccc4fbc637db25b0a7318b79f16a66d1b660d483742ef6a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm@14" # Needs LLVM 14 for `csound`.

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
