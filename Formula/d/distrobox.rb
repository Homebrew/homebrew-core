class Distrobox < Formula
  desc "Use any Linux distribution inside your terminal"
  homepage "https://distrobox.privatedns.org/"
  url "https://github.com/89luca89/distrobox/archive/refs/tags/1.7.0.1.tar.gz"
  sha256 "40a366955385efbf79c170e92bb14d4e2ae66b253bafa0ddb49ec39c4bd2b616"
  license "GPL-3.0-only"
  head "https://github.com/89luca89/distrobox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e83156f5b1384e7463a2534eb4897c565e80ad6f5518f8df6bbdcbf9ffd16338"
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
