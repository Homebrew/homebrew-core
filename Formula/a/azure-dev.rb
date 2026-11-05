class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.37.3.tar.gz"
  sha256 "8d7e6f8436147a4f94e5435598331ebdd5f134d719d4d7016bcce4d6253c680d"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f8d92213e1b71008263ae49d0380a6fbb6319a3903128db975749f8944573740"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f8d92213e1b71008263ae49d0380a6fbb6319a3903128db975749f8944573740"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f8d92213e1b71008263ae49d0380a6fbb6319a3903128db975749f8944573740"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a713f9eed6a1692d55282ec09ea61c2d37c0f50a31b00034219439d4ba8f7f88"
    sha256 cellar: :any,                 x86_64_linux:      "8cb256b6a568f14b6bdf8683d1a6e7d514d188caaa8d7be40aeec2d8e8ca6868"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "cli/azd"
  end

  def install
    # install file to be used to determine if azd was installed by brew
    (libexec/".installed-by.txt").write "brew"
    inreplace "cli/azd/pkg/installer/installed_by.go",
              'Join(exeDir, ".installed-by.txt")',
              'Join(exeDir, "..", "libexec", ".installed-by.txt")'

    # Version should be in the format "<version> (commit <commit_hash>)"
    azd_version = if build.stable?
      "#{version} (commit 0000000000000000000000000000000000000000)"
    else
      "#{File.read("cli/version.txt").strip} (commit #{Utils.git_head})"
    end
    ldflags = %W[-X "github.com/azure/azure-dev/cli/azd/internal.Version=#{azd_version}"]
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
