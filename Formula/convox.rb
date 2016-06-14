class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://bin.equinox.io/a/9RUvivxx6Lm/convox-20160606232025-darwin-amd64.tar.gz"
  version "20160606232025"
  sha256 "ad9c6cee12b8b34096ee7ce85cd980a5b1784cc05e02df8e1be1ef3ce86a684d"

  def install
    bin.install "convox"
  end

  test do
    system "#{bin}/convox"
  end
end
