class AirdropCli < Formula
  desc "macOS CLI for AirDrop"
  homepage "https://github.com/vldmrkl/airdrop-cli"
  url "https://github.com/vldmrkl/airdrop-cli/archive/1.0.0.tar.gz"
  sha256 "525139ebb848a88db661bfda4bc685ba9cb8c3ba92801c7666f5590e6525beee"
  license "MIT"
  head "https://github.com/vldmrkl/airdrop-cli.git"

  depends_on xcode: "11.4"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    mv ".build/release/airdrop", "airdrop"
    bin.install "airdrop"
  end

  test do
    system "#{bin}/airdrop", "-h"
  end
end
