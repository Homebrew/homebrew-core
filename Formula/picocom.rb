class Picocom < Formula
  desc "Minimal dumb-terminal emulation program"
  homepage "https://github.com/npat-efault/picocom"
  url "https://github.com/npat-efault/picocom/archive/3.0.tar.gz"
  sha256 "a539db95bde3a5ebd52ae58a21f40d00cc2c97bf14b1f50caffc07257989112e"

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
