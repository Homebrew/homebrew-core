class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "c836276c5d496017b6a64cb28735bf62e49b88fde096334ccc8b617f58fd0d52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9343027cb8d96b98bf09de22daf2c79967d58f721b2ccb3daf94db9c7b7c045"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ccde3299fc1b821f63cce65547da65a40e0c7e5578d2bea4310bb1862e2c2bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01e204d62832f31bf4c70163c309e084852c4705020fca900e3de6ee720dea38"
    sha256 cellar: :any_skip_relocation, ventura:        "401efe75f710a7c08213364c402ea59b3e32eb00c5d396bbc224da632d1ae384"
    sha256 cellar: :any_skip_relocation, monterey:       "87b98377e3d6825a1d9a6904420fa174b86868a91968a1c2b93483e2101f00d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "dcab599377f137fcc7874e7589d99b4aff6bc820103c77c39f1afad3553d6152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45a7a0449802fdf88e92f1cbc35aa5ee7282402ab48f0fcb6e16a8b9bf0996a9"
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
