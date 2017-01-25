class Morse < Formula
  desc "Morse-code training program and QSO generator"
  homepage "http://www.catb.org/~esr/morse/"
  url "http://www.catb.org/~esr/morse/morse-2.5.tar.gz"
  sha256 "476d1e8e95bb173b1aadc755db18f7e7a73eda35426944e1abd57c20307d4987"

  depends_on :x11

  def install
    system "make", "all", "DEVICE=X11"
    bin.install "morse"
    man1.install "morse.1"
  end

  test do
    system "#{bin}/morse", "--version"
  end
end
