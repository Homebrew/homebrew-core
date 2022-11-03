class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "8938e52fc47d2e1b777046a6e878effdcaab5c62341b856ee767ebc25c4d9dcb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9632ea5d6886ca9f5b4c2df5c68572b712cb52b50fe936f89b4bedb1fefce703"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4abe655e917ef017b52130b4f8838cd71f50efd70fe092c05eceb8a80a3ee30f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7bcc94c7f263499892dfa8e2093ace2b484a6bdcf889a89cc724404c069f3fe0"
    sha256 cellar: :any_skip_relocation, monterey:       "3a82dc4e163777ab2d7a90114a91e65a6cad5bec7d78939229877d8544c9aa96"
    sha256 cellar: :any_skip_relocation, big_sur:        "7481d954f3db03ff04b814de7389d43003af34b829a26d804cf9608d56910d22"
    sha256 cellar: :any_skip_relocation, catalina:       "4337fb2fdb2bb5469ea807b903cbd62344dce13ea9197491e0a3b4566ce74a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86ee89f67120782bc5f72a03b2774a182e38039517e2685ff51fd83da29e8be7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
