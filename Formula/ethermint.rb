class Ethermint < Formula
  desc "Ethereum powered by Tendermint consensus"
  homepage "https://github.com/tendermint/ethermint"
  url "https://s3-us-west-2.amazonaws.com/tendermint/binaries/ethermint/0.5.3/ethermint_0.5.3_darwin-10.6-amd64.zip"
  version "0.5.3"
  sha256 "75040beb16b8fae6932a893616a2e3f8ee20a2e7957befecb7d7d5fcdf0e5ab9"

  bottle :unneeded

  def install
    bin.install "ethermint"
  end

  test do
    ethermint_version = shell_output("#{bin}/ethermint version").split("\n").first.partition("  ")[2]
    ethermint_version_without_hash = ethermint_version.partition("-").first
    assert_match version.to_s, ethermint_version_without_hash
  end
end
