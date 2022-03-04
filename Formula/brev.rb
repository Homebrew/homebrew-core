class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.23.tar.gz"
  sha256 "d9d60f4d5fad3c8ea6bc33ee278e5be8f2bd63707b12745245084ababcfaeb2f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "632dacee15cb122342a271f2a90a0d206540822ef1697be3de04c2273c4e1386"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1e12f88451b5706b11d9634c5379840ca3f2318b37f96a9b1834c92540717b3"
    sha256 cellar: :any_skip_relocation, monterey:       "7123ce3671c5fedb283824123244c7840c7a8134c861d0ff00f3317960333551"
    sha256 cellar: :any_skip_relocation, big_sur:        "47c2974ea4a0320d00ba129f7d69a810f29860c40909143ee43f7668d4ea0b9e"
    sha256 cellar: :any_skip_relocation, catalina:       "1eb8ce9497edbc74672db9d651b2edde5af0a6ee64e59a10e5bd016ff8559578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b6728f94257f3fbb7fb9583e376259c649ef4ed5f5449e14c4de2716bceb9d1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
