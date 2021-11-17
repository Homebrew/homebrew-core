class Mirror < Formula
  version = "1.2"
  desc "Command-line tool for fiddling with display mirroring: on/off/toggle"
  homepage "https://fabiancanas.com/open-source/mirror-displays"
  url "https://github.com/fcanas/mirror-displays/releases/download/v#{version}/mirror.zip"
  sha256 "3a44b1e65fdbcd15ba93ec1a1af97e205c8d274cb0272a40940add9f62853e2f"
  license "GPL-3.0-or-later"

  resource "source" do
    url "https://github.com/fcanas/mirror-displays/archive/refs/tags/v#{version}.tar.gz"
    sha256 "96db4c12e8f6606db9822af54da35daaae0bff6853df7347cefdccd07a7e6acc"
  end

  def install
    bin.install "mirror"
    resource("source").stage do
      man1.install "mirror.1"
    end
  end

  test do
    assert_match "Mirror Displays version #{version}", shell_output("#{bin}/mirror -h")
  end
end
