class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "ecd3e2cf3a298965a0e72b3cc187d5d98fd93fb6d6aac65b117d647b849dc1e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb7adb4a9c5b2cd2646ef97d0228526fa341830836e13b26d9103c5819b62cb7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb7adb4a9c5b2cd2646ef97d0228526fa341830836e13b26d9103c5819b62cb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb7adb4a9c5b2cd2646ef97d0228526fa341830836e13b26d9103c5819b62cb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ebe80248b47b1acaae80f252af05d74a7c3020726dc1c1fb85726d9e5e8b5a88"
    sha256 cellar: :any,                 x86_64_linux:      "a1d5411f6f733643d39d2530882d40b110a072f4c710f3ecd8ac6d812334d0dc"
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
