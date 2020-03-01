class Proji < Formula
  desc "Powerful cross-platform CLI project templating tool"
  homepage "https://github.com/nikoksr/proji"
  url "https://github.com/nikoksr/proji/releases/download/v0.19.0/proji-macOS-64bit.tar.gz"
  version "0.19.0"
  sha256 "a9a488650fd4a964c4cccf4d816e04cb6886f94f50fa1d0fefa14be033f01c5b"
  bottle :unneeded

  def install
    bin.install "proji"
    system "#{bin}/proji", "init"
  end

  test do
    system "#{bin}/proji", "version"
  end
end
