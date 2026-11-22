class Kubecolor < Formula
  desc "Colorize your kubectl output"
  homepage "https://kubecolor.github.io/"
  url "https://github.com/kubecolor/kubecolor/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "2b2b9d845f5eadd025c16718c6f0e62557cc345fef1c036292c62f9473964301"
  license "MIT"
  head "https://github.com/kubecolor/kubecolor.git", branch: "main"

  bottle do
    manifest_sha256 "745180e8e932c5ff5734c733638bd7764288c0cf291ee74d4c1698c7d3df215d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "24399f44b9380f07abd26927bb03e282b9ae2cf1dab5f8d065b6b5fd6068e793"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "24399f44b9380f07abd26927bb03e282b9ae2cf1dab5f8d065b6b5fd6068e793"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "24399f44b9380f07abd26927bb03e282b9ae2cf1dab5f8d065b6b5fd6068e793"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f30c403f4cf8ba382c3c8f5a2e34fb9fadae8edc4ee94b2f97e39d97769927bf"
    sha256 cellar: :any,                 x86_64_linux:      "136993e3cb2399bdcbe44556fdeabdab0a5e500aabd967763c6a582b3e706368"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=v#{version}"

    system "go", "build", *std_go_args(output: bin/"kubecolor", ldflags:)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/kubecolor --kubecolor-version 2>&1")
    # kubecolor should consume the '--plain' flag
    assert_match "get pods -o yaml", shell_output("KUBECTL_COMMAND=echo #{bin}/kubecolor get pods --plain -o yaml")
  end
end
