class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.4.2.2",
      revision: "6c6b140ad8ab1d762e2a4ce79d67786063482238"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ba2f9b20874229f4cd6fdd65f312417530ef0eff689075fb6212c8a3b0803f6f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ba2f9b20874229f4cd6fdd65f312417530ef0eff689075fb6212c8a3b0803f6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba2f9b20874229f4cd6fdd65f312417530ef0eff689075fb6212c8a3b0803f6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3dd0159f6d8a6a0ec24cb022f43ac8fe5336ebd583b1cc37c1c0d23681f6cc33"
    sha256 cellar: :any,                 x86_64_linux:      "a4be83f1e516c4e0a75c24088a0fd7958c165c95ce26038b30edf168408f460a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end
