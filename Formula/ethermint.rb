class Ethermint < Formula
  desc "Ethereum powered by Tendermint consensus"
  homepage "https://github.com/tendermint/ethermint"
  url "https://github.com/tendermint/ethermint/archive/v0.5.4.tar.gz"
  sha256 "b571f316841513efa16d8c62c8eeddac3f947af591f964aa3e3b1bb55f10f732"

  bottle do
    cellar :any_skip_relocation
  end

  head do
    url "https://github.com/tendermint/ethermint.git",
      :branch => "develop"
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ethermintpath = buildpath/"src/github.com/tendermint/ethermint"
    ethermintpath.install buildpath.children
    cd ethermintpath do
      system "make", "get_vendor_deps"
      system "make", "build"
      bin.install "build/ethermint"
    end
  end

  test do
    ethermint_version = shell_output("#{bin}/ethermint version").split("\n").first.partition("  ")[2]
    ethermint_version_without_hash = ethermint_version.partition("-").first
    assert_match version.to_s, ethermint_version_without_hash
  end
end
