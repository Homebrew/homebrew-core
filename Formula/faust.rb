class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.50.6/faust-2.50.6.tar.gz"
  sha256 "d8b7a89d82ee5d3259c8194c363296bc13353160f847661ab84b2dbefdee7173"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "82960a34b3d086c771fb8fc5a81d76c8320fe8d8c3dcd2b71abb3febd885feba"
    sha256 cellar: :any,                 arm64_big_sur:  "ada2aa5feeff5e6cce7a130c359a94f0475210f4362471c69ee8a69d4254e40b"
    sha256 cellar: :any,                 monterey:       "4039148223dd9d051b73b0734f49b67cae1013080bd938f3891b1f2e4741b457"
    sha256 cellar: :any,                 big_sur:        "73964cdae017ca1cdeba8850cb055f16535186c02b79d346d2a54356fdf5e9b5"
    sha256 cellar: :any,                 catalina:       "b80ba177994f548499ddfb496a619bd4054d7c3f2af23cb3bafc26ed42f5a47f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "806029859938cc14f50b735e75d01afc836eeab167b83893580a6385c63a8408"
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
