class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https://github.com/linki/chaoskube"
  url "https://github.com/linki/chaoskube/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "05c6d31cc1ecdffdd59b3634ba892d26e19b4dd09f7d3993dcc3840328f4a2c2"
  license "MIT"
  head "https://github.com/linki/chaoskube.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "1e757453f213bc85991ba0de972681fa487ed8d003590928a3f5cd3673a52eca"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e5274541c08606e88a91bc9f26757057b185b86b5898d8987d05febdaa265002"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f7cfd7976e8967f890a77051abe69ed9e380a6fe3bfc206af8dd018cc3513089"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fabae85d3bfb682e587eea795c46e012975119289652068d904f949ad09c286f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "afc17c42578cc73c04fe9e7f3f3758c0e9f0225b4a6b22868be9adbb7d6a8fdf"
    sha256 cellar: :any,                 x86_64_linux:      "714abaf918fe66f3e7d46916893d3dee0b64adfab98e497da082356035701b0e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/chaoskube --labels 'env!=prod' 2>&1", 1)
    assert_match "dryRun=true interval=10m0s maxRuntime=-1s", output
    assert_match "Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.", output

    assert_match version.to_s, shell_output("#{bin}/chaoskube --version 2>&1")
  end
end
