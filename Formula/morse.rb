class Morse < Formula
  desc "Morse-code training program and QSO generator"
  homepage "http://www.catb.org/~esr/morse/"
  url "http://www.catb.org/~esr/morse/morse-2.5.tar.gz"
  sha256 "476d1e8e95bb173b1aadc755db18f7e7a73eda35426944e1abd57c20307d4987"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fe911c0c4d71783759f9d8c4e6269c873a830d0511e0813edf7ec86f3c7f62f" => :mojave
    sha256 "fb58a8af73002f98fe7ff1274c1712eb4bf0cab8b08640d2836fc6951c5cb2e9" => :high_sierra
    sha256 "d779902b961e9ebbfa41b0906d8d41357232fd4da83a393e112cde87f5bcdcaa" => :sierra
    sha256 "491a1ea5455d058af9adb607e0e49d95b94e52f0068cd5fb197c1ea71666b524" => :el_capitan
    sha256 "c89c45cdc2ff59d6ac327188c484659c769fe94a07e5e1f38f4d568f0b1a943d" => :yosemite
  end

  depends_on :x11

  def install
    system "make", "all", "DEVICE=X11"
    bin.install "morse"
    man1.install "morse.1"
  end
end
