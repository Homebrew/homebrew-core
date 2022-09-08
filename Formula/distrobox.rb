class Distrobox < Formula
  desc "Use any Linux distribution inside your terminal"
  homepage "https://distrobox.privatedns.org/"
  url "https://github.com/89luca89/distrobox/archive/refs/tags/1.4.0.tar.gz"
  sha256 "e643a702c3f3f0d7467afe840b4f3ee6e4c369b6464618b6ec09f7ad27eb64f5"
  license "GPL-3.0-only"
  head "https://github.com/89luca89/distrobox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b738dfe47d736a722fcd5b9d3617d7e92a661341da553e17ac02a5ebef8627eb"
  end

  depends_on :linux

  def install
    system "./install", "--prefix", prefix
  end

  test do
    system bin/"distrobox-create", "--dry-run"
  end
end
