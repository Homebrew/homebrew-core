class Alt < Formula
  desc "command-line utility to find alternate file"
  homepage "https://github.com/cyphactor/alt"
  url "https://github.com/cyphactor/alt/archive/v0.0.1.tar.gz"
  version "0.0.1"
  sha256 "9b12d298580774e285b49aabc0ef511eb46561cd16cf89088431f02dac2326ea"

  bottle :unneeded

  depends_on :ruby => "1.9"

  def install
    bin.install "alt"
  end

  test do
    system "#{bin}/alt", "--version"
  end
end
