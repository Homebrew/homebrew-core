class Lv2 < Formula
  desc "Portable plugin standard for audio systems"
  homepage "https://lv2plug.in/"
  url "https://lv2plug.in/spec/lv2-1.16.0.tar.bz2"
  sha256 "dec3727d7bd34a413a344a820678848e7f657b5c6019a0571c61df76d7bdf1de"

  bottle do
    cellar :any_skip_relocation
    sha256 "46bf661246f48276cdffd3e7f0fc04b26776afd7ccb1fc8a14750f67e151e47a" => :catalina
    sha256 "5c5ae73974d83d50004207ad39161c5083d4246213c0140bded36d267a126a08" => :mojave
    sha256 "5c5ae73974d83d50004207ad39161c5083d4246213c0140bded36d267a126a08" => :high_sierra
    sha256 "b0f163fce66e26fefa0c1dc35db01662d5bacae2f96760e4e5b79b1ec383cfed" => :sierra
  end

  depends_on :macos # Due to Python 2

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--no-plugins", "--lv2dir=#{lib}"
    system "./waf", "build"
    system "./waf", "install"
  end
end
