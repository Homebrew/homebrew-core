class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://github.com/skippbox/kompose"
  url "https://github.com/skippbox/kompose/releases/download/v0.1.0/kompose_darwin-amd64.tar.gz"
  sha256 "2cd1836fc0d5cd62bb72fb923cba98665c586087967b205b53dbcf2cdea9a9aa"

  bottle :unneeded

  def install
    bin.install "kompose"
  end

  test do
    system "#{bin}/kompose", "--version"
  end
end

