class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.36.tar.gz"
  sha256 "f16d2bda76ae1fd5be6d26664b96302b5d4d22ca6581d46cf98d279226852834"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8c7edc16295bdf7747ec3cbfc5e3c7de3690684cc2c9b29d2b6efaae3afa953"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e046a7bdc293f10bf28eda2a4ede1f30a3febba7f74dd5981900d4f3fffd1b8c"
    sha256 cellar: :any_skip_relocation, monterey:       "86c50584067fdf2c3db61058d6f850845edf7c82e6d470a58a41a90848860a37"
    sha256 cellar: :any_skip_relocation, big_sur:        "9617329a31e9497180626eba0e728a21d70abc1321dd39d3cc8caf9405d2ed65"
    sha256 cellar: :any_skip_relocation, catalina:       "1e6ee74d3e704909291564c80e0cc944c163e1080ac2f55440669e26a51c6715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5512cf37a96986d2524e8b48752808ce10bb2ab911bf41b97917994b72025643"
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
