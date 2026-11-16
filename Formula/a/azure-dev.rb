class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.38.0.tar.gz"
  sha256 "fde670a6a011bf66c9eb875b8287fd065a8f256e9d5461dc6469c7255a679cd5"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5c661ef7d146256710ff48137ad566ac39edde905ae1095932e50cbcc0cabca4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5c661ef7d146256710ff48137ad566ac39edde905ae1095932e50cbcc0cabca4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5c661ef7d146256710ff48137ad566ac39edde905ae1095932e50cbcc0cabca4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9163669236d3ea06c3964459d13348c165ab37bf2507e58850f3963eff481641"
    sha256 cellar: :any,                 x86_64_linux:      "60d27ccc139aa913b638230083fc69e223aba9d1ff4ba711934a2c0a4e8dd436"
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
