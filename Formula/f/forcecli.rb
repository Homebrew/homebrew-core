class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "9ad6f8b36b945f211b5a5904b4e538d5c30be216d71008860b09fd00619cb30a"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "52191a2927f2f3d134526f154b735120116c3c801002022085e2bbc0009be72e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52191a2927f2f3d134526f154b735120116c3c801002022085e2bbc0009be72e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52191a2927f2f3d134526f154b735120116c3c801002022085e2bbc0009be72e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b4a84a5bfd768cdc09ed3867705cc136daa3a0aed9e91a735add55d0c4a95248"
    sha256 cellar: :any,                 x86_64_linux:      "633f0cb8ebab217e3f8dce324a72ad68c8bb5869687a503172f16222b8e5e855"
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
