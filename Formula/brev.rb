class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.197.tar.gz"
  sha256 "1a25e9e6935c3dbbd85a5fdee823bf0f2c63d00ca857d82c84d4cd9bc93900d6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65164944bfbe882a4bccee3828cffa525459aa25d7bf4f6344d3394821828b10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "436d6537b0c0e8aa01d39cb1edce2e181459c10336dbdcc23acc6aa1acd5bc68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72a85eddde221ed9357a5a490bb50353cdf83cde6932bf03d84d9d1535005637"
    sha256 cellar: :any_skip_relocation, ventura:        "cf408533a49362d2efd25d4d3ccef335634590b22914f642d8ff920ef3dc77bf"
    sha256 cellar: :any_skip_relocation, monterey:       "0cd2a03970642563760f24e7c9342cfbdc7b66e2124b5ccfa441eb000fcb339e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c9a9fd334854eaaa69d9cc81b4d9841d7ff0d3a1df0a55e38ba9a6b53541d8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f46b197f29a51b7ce9dc3a1eb2be9cf7eeb573d13504c323ec02e247ad92b0c3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
