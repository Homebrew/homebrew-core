class IpfsUpdate < Formula
  desc "CLI tool to help update and install IPFS easily"
  homepage "https://dist.ipfs.io/#ipfs-update"
  url "https://dist.ipfs.io/ipfs-update/v1.5.2/ipfs-update_v1.5.2_darwin-amd64.tar.gz"
  version "1.5.2"
  sha256 "9f7017fe7453fd42b35a52d631ba4765fdc0e6d0cd890f0eb1a12a64f086c922"

  def install
    bin.install "ipfs-update"
  end

  test do
    system "#{bin}/ipfs-update", "--version"
  end
end
