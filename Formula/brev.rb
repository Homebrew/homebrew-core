class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.199.tar.gz"
  sha256 "ad0468dd6a7100d0044141384f0dec6b8351e33d8cedaf09c4cba6e67f77d2b7"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bb0e9667e7b51a3f1ac5b374dcab5bfc2bac50546248d34e55f8ac0867c737c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecb7254b887737c8287e58f48a2adc0a44abe30dfefe9ca5a426761b1dbe2303"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0227319a29393352376fc9ebd45e23984f2065d2bdad58237c2c0bf7627449e4"
    sha256 cellar: :any_skip_relocation, ventura:        "3a39bed3fec6f83d991ac2c5e977c72efc557a249743a8b97063774f23343a37"
    sha256 cellar: :any_skip_relocation, monterey:       "1e98f24c7060c40c682bf63a1752aefec27862624beb8ea4a0911459dded0257"
    sha256 cellar: :any_skip_relocation, big_sur:        "c20b6d1842e6715fc9592bc26da329255454c429610b2ba3b06fd9bfd2a6cbbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e70d84eed29faea6214f2a1b20d5b59b60735208d095415638fad11f2a4656a7"
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
