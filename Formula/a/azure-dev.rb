class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.25.0.tar.gz"
  sha256 "805e8779aee37f4d8526d19ec7121c8c71a138eab1d73643536fed88b29313db"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fac925d24d91615b6833c06176cea96fe02fefcb11c309c7f9aa9d06ccb21db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fac925d24d91615b6833c06176cea96fe02fefcb11c309c7f9aa9d06ccb21db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fac925d24d91615b6833c06176cea96fe02fefcb11c309c7f9aa9d06ccb21db"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1e7c93c2b5a296e9e3125058f9830b6f71834c9395693c6e9ee2ddfdbcee80b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fd42c0c22e1dc7d2aa32ae3e5bfdcb9817029f89040ed7de9e5d581afa6dafb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49f65e38465a84a85b9f8a27fa97b11f0b371427852247bf2b7bbe603e2c3594"
  end

  depends_on "go" => :build

  def install
    # install file to be used to determine if azd was installed by brew
    (libexec/".installed-by.txt").write "brew"
    inreplace "cli/azd/pkg/installer/installed_by.go",
              'Join(exeDir, ".installed-by.txt")',
              'Join(exeDir, "..", "libexec", ".installed-by.txt")'

    # Version should be in the format "<version> (commit <commit_hash>)"
    azd_version = "#{version} (commit 0000000000000000000000000000000000000000)"
    ldflags = %W[
      -s -w
      -X "github.com/azure/azure-dev/cli/azd/internal.Version=#{azd_version}"
    ]
    system "go", "build", "-C", "cli/azd", *std_go_args(ldflags:, output: bin/"azd")

    generate_completions_from_executable(bin/"azd", shell_parameter_format: :cobra)
  end

  test do
    ENV["AZURE_DEV_COLLECT_TELEMETRY"] = "no"
    ENV["AZD_DISABLE_PROMPTS"] = "1"
    ENV["AZD_CONFIG_DIR"] = (testpath/"config").to_s

    assert_match version.to_s, shell_output("#{bin}/azd version")

    system bin/"azd", "config", "set", "defaults.location", "eastus"
    assert_match "eastus", shell_output("#{bin}/azd config get defaults.location")

    expected = "Not logged in, run `azd auth login` to login to Azure"
    assert_match expected, shell_output("#{bin}/azd auth login --check-status")
  end
end
