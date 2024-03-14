class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "edc3109e365494e801fc752a5e52e3e2290153bccab2e96cc62df828bf87f289"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37f3f2f2f68f77c94fb142b2ecc001039e761e922afd11fcfc845d2f1f910801"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f061a8c57333326ba6080851cab8aac1920b82e820b29e3dbb7e70db762c744e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcbd0996fe14d639e4a45734902a053a175eebf6670227fa6edd073815f2626f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d952a00ca9d809d959176c2e0c0b7215c4922f84260f27f7cc3efe19d4db2c60"
    sha256 cellar: :any_skip_relocation, ventura:        "0251de26b1936f3ce6a17ff6d631ad8e57606c94d229a576e40be5024d9164d8"
    sha256 cellar: :any_skip_relocation, monterey:       "18a6517f68172f07fec944c2a0daf9098c82a65e3f136c591a96f309bb839076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34524df2ab10048b7b7e5e2c81ab4a2ba538815e033373bac38718df88eeb22c"
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
