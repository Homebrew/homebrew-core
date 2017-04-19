class GyazoCli < Formula
  desc "CLI tool for Gyazo."
  homepage "https://github.com/Tomohiro/gyazo-cli"
  url "https://github.com/Tomohiro/gyazo-cli/releases/download/0.4.1/gyazo_0.4.1_darwin_386.zip"
  sha256 "4eb4ba49ac35e0b74866341339ef841bd1733b7251e70a67ed1c9d5d77ba7b7d"

  bottle :unneeded

  def install
    prefix.install "gyazo"
    bin.install_symlink prefix/"gyazo"
  end

  test do
    system bin/"gyazo"
  end
end
