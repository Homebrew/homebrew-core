class KubectlRadar < Formula
  desc "Missing open-source Kubernetes UI with a built-in MCP server for AI agents"
  homepage "https://radarhq.io"
  url "https://github.com/skyhook-io/radar/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "b8052f5180ec6cd1e0a32938b4d2ebaa0168eb8bda15a23b5c79f0da172eee5c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "4974a04b072b049d96bf0a450be892921dac7eac5a38e2430ad58e1a8c5cdbf1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3b1019a573a13ac33ae1bdd109aa5c3a630e971ef326a84a0bf6d206ca479844"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f23cd744474ef160287a96cf3bbe3d786eff33d8ebf6fa2f05232252866a7f30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "136d7d19a10edf6384ac8c7aa95880b539c6e577dfa1a510b2f204a65b858095"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "afac96bea3e4b66d7f98db96e857aa5a183fc35780fe12389b99f1e69ed0b67d"
    sha256 cellar: :any,                 x86_64_linux:      "b20a07a0281559d498d5fac5a26bb6ad15d7dc26c3fc8d9b3bdd511e363a0efc"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    system "npm", "ci", *std_npm_args(prefix: false)
    system "go", "mod", "download"
  end

  def install
    system "make", "build", "-j1", "VERSION=#{version}"
    bin.install "radar" => "kubectl-radar"
    bin.install_symlink "kubectl-radar" => "radar"
  end

  test do
    assert_equal "radar #{version}", shell_output("#{bin}/kubectl-radar -version").chomp
    assert_match "failed to initialize K8s client",
      shell_output("#{bin}/kubectl-radar 2>&1", 1)
  end
end
