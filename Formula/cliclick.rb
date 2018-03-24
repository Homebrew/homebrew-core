class Cliclick < Formula
  desc "Tool for emulating mouse and keyboard events"
  homepage "https://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/4.0.tar.gz"
  sha256 "8d5a57cea0cb5a6cd8427ea2204909533574167f77518556f3f0a5b7548c0105"
  head "https://github.com/BlueM/cliclick.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "769a5a92d635e7eeaf6f0c07f6db7257ef0ad7a37f300525ad40da2c6d9efd4a" => :high_sierra
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
