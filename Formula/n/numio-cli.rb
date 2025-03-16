class NumioCLI < Formula
  desc "Numio CLI is a command-line tool written in Swift to perform time calculations."
  homepage "https://github.com/neholos/numio-cli"
  url "https://github.com/neholos/numio-cli/releases/download/v1.0.0/numio-cli-1.0.0-macOS.zip"
  sha256 "5ef6083204e4dc2ab77f367ca78f4d296d4a599420d6f4fc85b433a89e2ce76e"

  def install
    bin.install "numio-cli"
  end

  test do
    system "#{bin}/numio", "--version"
  end
end
