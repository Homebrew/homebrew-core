class Picocom < Formula
  desc "Minimal dumb-terminal emulation program"
  homepage "https://github.com/npat-efault/picocom"
  url "https://github.com/npat-efault/picocom/archive/3.1.tar.gz"
  sha256 "e6761ca932ffc6d09bd6b11ff018bdaf70b287ce518b3282d29e0270e88420bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c4c7aa2526c4cc4a51b269b45cd64ef13332654ea89dcb766e82c5a854d6342" => :high_sierra
    sha256 "51d0909d18a489127656a08631ca1f11260cef6e28594442b54c9948df651ba5" => :sierra
    sha256 "848326ca1dabf4b956f336b1d24c4a96df0c313c7f653e408dcaae41278cc1d0" => :el_capitan
  end

  def install
    system "make"
    bin.install "picocom"
    man1.install "picocom.1"
  end

  test do
    system "#{bin}/picocom", "--help"
  end
end
