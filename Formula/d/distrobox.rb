class Distrobox < Formula
  desc "Use any Linux distribution inside your terminal"
  homepage "https://distrobox.privatedns.org/"
  url "https://github.com/89luca89/distrobox/archive/refs/tags/1.8.1.2.tar.gz"
  sha256 "3ecbce9b8c5b5df941f986798ffa6ea7fdf742223d42204207974c4323d5b9fc"
  license "GPL-3.0-only"
  head "https://github.com/89luca89/distrobox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "98aec5e4ae61cf3ac4284185e988291eccb4d870b16a156d661bfcfd4580d4ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "98aec5e4ae61cf3ac4284185e988291eccb4d870b16a156d661bfcfd4580d4ae"
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
