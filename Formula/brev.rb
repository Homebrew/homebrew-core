class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.74.tar.gz"
  sha256 "8c497da171ff2025561753231999d2444283e4b0db7ffb6ec89664b2ff3b37ad"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c12ff56b92f54c675df12655cae188a5d44e063c1ad6a8f855fe5d0415acb79f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "447b1e152c5426b251c6eb0cd6c3ff4df4037402893ff29fb2ea0c7e33685e70"
    sha256 cellar: :any_skip_relocation, monterey:       "2ee876d7142705e2e750c0acfea7aac4570ae83aff5fbcc8ed2df5fd393c188b"
    sha256 cellar: :any_skip_relocation, big_sur:        "997c4d90d4db3fbee7b9e18ac0626e5ea3669bb46d2eb01349eb80e5084edd7e"
    sha256 cellar: :any_skip_relocation, catalina:       "3a580a972cdf226d47e3c6f74f260682f4668d10d348324892dbf94c3caa66b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8fbf8c0cfa0db65d393e6501918edb366c31ec1545c401c2d9ced586f0f3b0e"
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
