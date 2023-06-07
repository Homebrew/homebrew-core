class Distrobox < Formula
  desc "Use any Linux distribution inside your terminal"
  homepage "https://distrobox.privatedns.org/"
  url "https://github.com/89luca89/distrobox/archive/refs/tags/1.4.2.1.tar.gz"
  sha256 "cbe9217315f848396ec1eb8e21929d23065caa6a1a55f8988500475e823b1f31"
  license "GPL-3.0-only"
  head "https://github.com/89luca89/distrobox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1f6c52b74824f52456bab567688685d454b3c759f3ed7e26e1f630b825f3a828"
  end

  depends_on :linux

  def install
    system "./install", "--prefix", prefix
  end

  test do
    system bin/"distrobox-create", "--dry-run"
  end
end
