class CobraCli < Formula
  desc "Tool to generate cobra applications and commands"
  homepage "https://cobra.dev"
  url "https://github.com/spf13/cobra-cli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "9c9729828a035eff012330d5e720eec28d2cb6a1dbaa048e485285977da77d15"
  license "Apache-2.0"
  head "https://github.com/spf13/cobra-cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "390cda2b8ba89e754ff53a554bd607688676c1f5e8e0c62af31921186e389a77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "390cda2b8ba89e754ff53a554bd607688676c1f5e8e0c62af31921186e389a77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "390cda2b8ba89e754ff53a554bd607688676c1f5e8e0c62af31921186e389a77"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2570b9dfc87d3a357c35cbb15924f092d9d34842511e280c287e421953ba8ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd7143538bec872061451a5e5cec71ac837e62434f3417e8c2d124fb884d7291"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "433e9e258e281a31d42a841ddbcf8cbf6329c45b290b29d3ce1c345aa78b3f52"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cobra-cli", shell_parameter_format: :cobra)
  end

  test do
    system "go", "mod", "init", "brew.sh/test"
    assert_match "Your Cobra application is ready", shell_output("#{bin}/cobra-cli init")
  end
end
