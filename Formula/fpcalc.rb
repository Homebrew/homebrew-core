class Fpcalc < Formula
  desc "`fpcalc` tool from the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.4.3/chromaprint-fpcalc-1.4.3-macos-x86_64.tar.gz"
  sha256 "159f3d0d8eb637d620f18251736917e54fda34d6bda42daf97ff5271fb78cb00"

  def install
    bin.install "fpcalc"
  end

  test do
    system "#{bin}/fpcalc", "-version"
  end
end
