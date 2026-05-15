class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "89d166488aa4f2c4e83d1a666a742ddd3f455043c5bb31e3d3a13e168a64b0a3"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06c2a0a2e7ebd9a798620691b6dfdd4401c8fb5e3d1edbce7657819045de0942"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06c2a0a2e7ebd9a798620691b6dfdd4401c8fb5e3d1edbce7657819045de0942"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06c2a0a2e7ebd9a798620691b6dfdd4401c8fb5e3d1edbce7657819045de0942"
    sha256 cellar: :any_skip_relocation, sonoma:        "099a3a8dcb9f7cd88cb18562eef8f26cebb5902225118bcc023f9bbe85c680f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a60aa2452a40ffb94da56869a2de72f0f5ca77c73c3f6a1e7f0951d48756c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40e80bf9e11e026b8da7347dfc57f1909d5cef78e861b4164974fcf53d11996f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"force")

    generate_completions_from_executable(bin/"force", shell_parameter_format: :cobra)
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
