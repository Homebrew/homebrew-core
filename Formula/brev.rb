class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.71.tar.gz"
  sha256 "c1b6633ff03870fb62a0a86ad1cd31c0af04cb17cd6744c972a3bc4637e7d2f5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2daa407d1479dde7cf9ba4b57caacb7f6c30b3c3cc6eff26b888595031054f29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "909b4b2cece99281e3b712803025d622efcc1020900b2845ac391fc5ba9e9bc9"
    sha256 cellar: :any_skip_relocation, monterey:       "c5de121afbaf247eb5c0a0b60bbf4c104b98ce1a5ef022ca53d3c3e3e89a7f22"
    sha256 cellar: :any_skip_relocation, big_sur:        "30b0cffd2b42a1c87cc2e81447d7b3202341a4a6b8da9d67e10968a27fe2c4a6"
    sha256 cellar: :any_skip_relocation, catalina:       "f48c980ec9fddf4d2c0591617024de0842d6dea4cef258787665fc165b38e0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cbb22ad0dfc69062a2f884837f4e24c2bac638e6cb2c3652387e8d8a5015704"
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
