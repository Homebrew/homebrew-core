class Distrobox < Formula
  desc "Use any Linux distribution inside your terminal"
  homepage "https://distrobox.it/"
  url "https://github.com/89luca89/distrobox/archive/refs/tags/1.8.2.6.tar.gz"
  sha256 "693c85f44720f9c2be8691141eaa1dc2773ee37e63ae02fff8b838dcf54c413e"
  license "GPL-3.0-only"
  head "https://github.com/89luca89/distrobox.git", branch: "main"

  bottle do
    manifest_sha256 "267200a562163a8c20f2b8bc50c5b758e67817bb28fa7d7fd059a3df49f2ffed"
    sha256 cellar: :any_skip_relocation, all: "47c1745517891cff236b37ed263c774b7a30c871946a32987065f3486c9b44ae"
  end

  depends_on :linux

  def install
    system "./install", "--prefix", prefix
  end

  def caveats
    <<~EOS
      Distrobox requires one of podman or docker. Do
        brew install podman
      or consult the documentation for details.
    EOS
  end

  test do
    system bin/"distrobox-create", "--dry-run"
  end
end
