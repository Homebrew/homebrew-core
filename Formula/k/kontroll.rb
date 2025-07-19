class Kontroll < Formula
  desc "Keyboard layout switcher for ZSA keyboards"
  homepage "https://github.com/zsa/kontroll"
  url "https://github.com/zsa/kontroll/releases/download/1.0.4/kontroll-1.0.4-macos-universal.zip"
  sha256 "fad2dde5d53114a8ff30ed75df414f169c13e00f04536e700c70785563811c5d"
  license "MIT"

  livecheck do
    url "https://github.com/zsa/kontroll/releases/latest"
    regex(%r{href=.*?/tag/(\d+(?:\.\d+)+)}i)
  end

  def install
    bin.install "kontroll"
  end

  test do
    system bin/"kontroll", "--version"
  end
end
