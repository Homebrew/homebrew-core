class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "934459399466fefd4544412887e26aee881edb66524597ed952cc4714ae68afa"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c7df2e9f75e88e17a5e1964df73a10fe7fd53fb118d02e2b23e6a2af830b84ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c7df2e9f75e88e17a5e1964df73a10fe7fd53fb118d02e2b23e6a2af830b84ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c7df2e9f75e88e17a5e1964df73a10fe7fd53fb118d02e2b23e6a2af830b84ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e45c28c74028c0ee2526d116c677df4c41913aaae4c92aeec99d97726cec84d"
    sha256 cellar: :any,                 x86_64_linux:      "ca35feebcba2854bb0fb64dd981330174b2e9f85211c8bfdb7e1d79af47c2995"
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
