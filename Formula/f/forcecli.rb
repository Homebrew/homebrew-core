class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "9ad6f8b36b945f211b5a5904b4e538d5c30be216d71008860b09fd00619cb30a"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d198d3b194cfc7f52112c54896328353c161842dfbfb0406ff7fe24e476f57fc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d198d3b194cfc7f52112c54896328353c161842dfbfb0406ff7fe24e476f57fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d198d3b194cfc7f52112c54896328353c161842dfbfb0406ff7fe24e476f57fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5aaec9a02d43a6e1ab14fde56d5e08b2980976fb4d3f8b76267c94b39e5b63d4"
    sha256 cellar: :any,                 x86_64_linux:      "b995bcc6f7a53a07f4d747bf10bb9914a94e92b1eb860f464da021a499c9b6d9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"force")

    generate_completions_from_executable(bin/"force", shell_parameter_format: :cobra)
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
