class Bagel < Formula
  desc "Inventory what matters on developer machines"
  homepage "https://github.com/boostsecurityio/bagel"
  url "https://github.com/boostsecurityio/bagel/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b7317200cfc6d7556c6c1fbeb244c8397f68fc2998348bf07dbdc4f9bed46506"
  license "GPL-3.0-or-later"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/bagel"
  end

  test do
    system bin/"bagel", "scan", "--strict"
  end
end
