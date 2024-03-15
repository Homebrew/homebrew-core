class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "20ca697efabfe623ef87e129a908d1f64ae736f29894cbbe411e236a16b03394"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0dd6437327a5a01109f5f99bbddc2e718bc94c73019c063a729d01a3863b6a65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c4269a7a773e6b449721c535de812f8bd69dd98c8cead99824fe90f563750d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d71c26fbd8949df1e855b695fbb5262bd9c447c076d48781314bc8e3a9963ecb"
    sha256 cellar: :any_skip_relocation, sonoma:         "05e587fb619384070c2e3ae0cb9fbd918d428b7972a7eaa9f8f563982ba283d4"
    sha256 cellar: :any_skip_relocation, ventura:        "3b5d2e01ed53b5de28db1c6e49b9c1e41f6d8b76924eb41fa997930dd4a5f182"
    sha256 cellar: :any_skip_relocation, monterey:       "c4b7bc9e0da096d133e0086e9dd0da18d4e30480e8272fdc4f1e42a6d9165871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b213af14658c65f445a86803aec32c44b21a579bb6b98f0c54f10eb34fa5a60"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/defaults.CLIVersion=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"cilium"), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version 2>&1"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
