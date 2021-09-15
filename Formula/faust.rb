class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.33.1/faust-2.33.1.tar.gz"
  sha256 "7185b43615588e4e52fac5f455ae0078661e20f87da806b31c4942ca377f9a0a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "408e07036801864f2e41bef989fcf378789a286d205cab9d2299e40d7d92ccf4"
    sha256 cellar: :any, big_sur:       "071c793ef6c12f81dbf18d3b2b8259376728892ae5c4bfef12334fc50510d12b"
    sha256 cellar: :any, catalina:      "695cb71022281a137a2a360afc17df4612f7739e6c5ff1542605ff59918e4908"
    sha256 cellar: :any, mojave:        "24af862cea2bdb7dc5435a3beca58b54622219a424b4998986ea9f98808c3702"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm"

  def install
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
