class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.20.2/faust-2.20.2.tar.gz"
  sha256 "bea8675446c5e5ef4ac4ba1fb1d64b3a2af99f5f293be0492ccaf32baf7fcb5c"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "48f36d87c5d99c94dd5480fd24aacf1d12f7a1e0910c7c51d1486d00c732ead7" => :catalina
    sha256 "1e1c7d96ce8b9aae9742fa9933e3b9f400a0396fb37f1acc493b7af99cee53fe" => :mojave
    sha256 "a304cdfea4858109db24f99a54f16b95ad451804fd569d1b601bb4ba01921452" => :high_sierra
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
