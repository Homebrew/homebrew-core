class Cliclick < Formula
  desc "Tool for emulating mouse and keyboard events"
  homepage "https://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/3.3.tar.gz"
  sha256 "e434a951f0ab0c44ee965058f382cb22ec2b9027acdd17679e1244af3117965a"
  head "https://github.com/BlueM/cliclick.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6585dee48ebd350a1c42cca05425f46193d4ce2e911cc58936848f3a75c7a61" => :sierra
    sha256 "a632b68221f49e4590425260482f0ba1084cfc7b9838721c4c02651edeb1ecbd" => :el_capitan
    sha256 "6474d5b2d232dbac0512f8435a447e17ed21f1c44d36c46b6edb94d239b797e7" => :yosemite
  end

  def install
    system "make"
    bin.install "cliclick"
  end

  test do
    system bin/"cliclick", "p:OK"
  end
end
