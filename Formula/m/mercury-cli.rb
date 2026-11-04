class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "f4d23126528c7417842ac47fbb9592777312474dd95f36bb43db09ff7e44b078"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f3f9c48d1dcb5c8bd6e4e44885df4c55dbaa21d323a9148942c0b7fde418bdc7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3f9c48d1dcb5c8bd6e4e44885df4c55dbaa21d323a9148942c0b7fde418bdc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3f9c48d1dcb5c8bd6e4e44885df4c55dbaa21d323a9148942c0b7fde418bdc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "34e9e80db88bdb4ca946ae8d292bdb4ca4f8cc1420f94736af2fff8eb4211c14"
    sha256 cellar: :any,                 x86_64_linux:      "e7ff733a24308521840b1343cee27319d458fe6e677af9c0ce78fcadd9e3a8a3"
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
