class Nats < Formula
  desc "Utility for NATS Server and JetStream administration"
  homepage "https://github.com/nats-io/natscli"
  url "https://github.com/nats-io/natscli/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "832f2fcd53de5eceeb9d497ab603cbf32698646dfe156d23b70553e40eb1438b"
  license "Apache-2.0"
  head "https://github.com/nats-io/natscli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "814deaeedd530ae32ef35d96fca56202640d75ead4a24ecec07687b9bfc55884"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "165673e92ba48954f7d1b3e3c4ca47f53beb9e3f640553ce07640f67a3161df0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e0a3936a8133f4753b8cf5341464784c13b7f3db08ed09ef6eb68ed5ffb7a27e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2c67f22255a269f86a81c69715a091866195a9465cd3cd878b3d35a87676e578"
    sha256 cellar: :any,                 x86_64_linux:      "d93bc98bc76cf8d88383117433fa28524bb509aae1a65ec4377faa208a6a3d94"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./nats"
    generate_completions_from_executable(bin/"nats", shells:                 [:bash, :zsh],
                                                     shell_parameter_format: "--completion-script-")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nats --version")
    assert_match "No known contexts", shell_output("#{bin}/nats context ls")
    assert_match(/^[A-Z0-9]+$/, shell_output("#{bin}/nats auth nkey gen user").strip)
  end
end
