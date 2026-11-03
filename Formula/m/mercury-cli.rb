class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "5719489d1e58962ebf1a209412b10fcdc2d0ee635527046423f8a2b62b2043b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3d92320f421a5cb7aefaead017ace40841dc2d3c380257dedaead02b7dcf8020"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3d92320f421a5cb7aefaead017ace40841dc2d3c380257dedaead02b7dcf8020"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3d92320f421a5cb7aefaead017ace40841dc2d3c380257dedaead02b7dcf8020"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "471d99e08b6740de6c61b2dc61e5ecf9d022c7428cf8794dd39e56ab6cdceff3"
    sha256 cellar: :any,                 x86_64_linux:      "7ac60726f11a15aa3a922bbdeee3729182fe6230cab52df9314af72262f4bb52"
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
