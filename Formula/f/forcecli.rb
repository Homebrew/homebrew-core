class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "8066d9919cd49fd651df5f70e9fe69f282d6af6043ee1d8c3b91f61160e4a0b0"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c027a1147a8b1349fa0f0c57e5e0bc99b24c7acdfeac2bf36387b477ca898e8d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c027a1147a8b1349fa0f0c57e5e0bc99b24c7acdfeac2bf36387b477ca898e8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c027a1147a8b1349fa0f0c57e5e0bc99b24c7acdfeac2bf36387b477ca898e8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c7e892790050daa6de21e87e88a3eb392114156e1aca4c295725a99e61d64bbd"
    sha256 cellar: :any,                 x86_64_linux:      "ac4d659cb5f8c3d32432d6a3db1cc19812046fb38a957c41c7505d1f05a59506"
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
