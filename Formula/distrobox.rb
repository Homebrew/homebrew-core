class Distrobox < Formula
  desc "Use any Linux distribution inside your terminal"
  homepage "https://distrobox.privatedns.org/"
  url "https://github.com/89luca89/distrobox/archive/refs/tags/1.4.1.tar.gz"
  sha256 "be3266f77011b30da5d0035e246d4e4a9360b7c90fbd8b90ac581165a00217b8"
  license "GPL-3.0-only"
  head "https://github.com/89luca89/distrobox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "466922b6aaa2240b66b25b61a5d844beb82cdff19e4d63a02760aec73a465dc3"
  end

  depends_on :linux

  def install
    system "./install", "--prefix", prefix
  end

  test do
    system bin/"distrobox-create", "--dry-run"
  end
end
