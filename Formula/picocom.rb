class Picocom < Formula
  desc "Minimal dumb-terminal emulation program"
  homepage "https://github.com/npat-efault/picocom"
  url "https://github.com/npat-efault/picocom/archive/3.1.tar.gz"
  sha256 "e6761ca932ffc6d09bd6b11ff018bdaf70b287ce518b3282d29e0270e88420bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "e087cd6b60814a9b0638d6bdcc3a79e154b40f5013a0247878c1f1ab35c8d077" => :mojave
    sha256 "7fec5e767653710fa87d0be9d97735550af70aeb32fdcba1c7c0159e9078ee1a" => :high_sierra
    sha256 "fb1bd439cb84f2667feee5e5c125ec9a51698e7d153c56decf95502848edc621" => :sierra
    sha256 "ec353723ddf1f785bd75bb3a0e9bd5e92adacbe5b4a86ed5dabe53d20b1a362c" => :el_capitan
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
