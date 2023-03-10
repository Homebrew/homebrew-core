class GqCli < Formula
  desc "Command-line interface for GQ"
  homepage "https://goquant.io"
  url "https://brickelldatabros1aboah.blob.core.windows.net/public/gq-cli-source-0.0.4.tar.gz"
  sha256 "6e2b86cf57035bba045d7db9f1d28ae83283cec6b0ed4335083f320374b951ba"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root=#{prefix}", "--path=.", "--debug"
  end

  test do
    system "#{bin}/gq"
    system "#{bin}/gq", "--help"
    system "#{bin}/gq", "config", "-p"
    system "#{bin}/gq", "binance", "-h"
  end
end
