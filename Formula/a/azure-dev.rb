class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.23.5.tar.gz"
  sha256 "d7e2bca5f4915f3e561b5d93fab22801f5336fbeb46e8fa4f3ed027faabe5292"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3d1ad189ea6f2cbbe7ad494eb76759c9a167d1ef0b57d938de0231cd9f63631"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3d1ad189ea6f2cbbe7ad494eb76759c9a167d1ef0b57d938de0231cd9f63631"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3d1ad189ea6f2cbbe7ad494eb76759c9a167d1ef0b57d938de0231cd9f63631"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fc6e115160355a01a7b23d92486dceddf073e3bc97bdfbbc2f338ebd78e69a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "195cc79654d50bd749b384527e65c0b00a9ae98e5d6143ed057331cce95eb5ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b80e6a01e1bc67b040bef16a611fb6e5b1953c04a4e8cc117dadbc79300155d2"
  end

  depends_on "go" => :build

  def install
    (buildpath/".installed-by.txt").write "brew"

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
