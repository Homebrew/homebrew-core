class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "064fcc7aeb36d20f6a826a5ba48bd998e980161be5a866c60104c6c194e7246e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8e2545f9c8a33d3632799c2b5d32c01d8ffc15c135406103ab4117fcfa8fb41a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8e2545f9c8a33d3632799c2b5d32c01d8ffc15c135406103ab4117fcfa8fb41a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8e2545f9c8a33d3632799c2b5d32c01d8ffc15c135406103ab4117fcfa8fb41a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3d49a60ff1a044b843caf5f0a0c7ac5f7b41f33e2448a07c483093ed63d3c74d"
    sha256 cellar: :any,                 x86_64_linux:      "244abe4b5280fd5d1fb5ab34a63b519928eb941c838cfd748b9ba4e620076161"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"mercury"), "./cmd/mercury"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mercury --version")
    assert_match "Authentication Status", shell_output("#{bin}/mercury status 2>&1")
    assert_match "Your dedication to modern banking has not gone unnoticed", pipe_output("#{bin}/mercury hat 2>&1")
  end
end
