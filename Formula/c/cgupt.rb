class Cgupt < Formula
  desc "Simple website blocker CLI tool (macOS + Linux)"
  homepage "https://github.com/prady8339/cgupt"
  url "https://github.com/prady8339/cgupt/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "6a3c706d847c05f910c7b55e3b2d7c90a58501f2c4d8e63b916b61baf5a15bf0"
  license "MIT"

  def install
    bin.install "bin/cgupt"
  end

  test do
    system "#{bin}/cgupt", "help"
  end
end
