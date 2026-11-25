class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.40.0.tar.gz"
  sha256 "71c9afebd5b625c460b26ecfaddd51a0a640dac3e5942fd763c2c2df19af393e"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    manifest_sha256 "7efce44a0005f74b570cfece4629a34d3559dc7e94ab82c74283f8a8cac04eb3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "377d82699c3995cdeabb57af4eab8791d5614acfeee17460c9ee406277890d22"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "377d82699c3995cdeabb57af4eab8791d5614acfeee17460c9ee406277890d22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "377d82699c3995cdeabb57af4eab8791d5614acfeee17460c9ee406277890d22"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4b0a8ac18bbdbcc9230b6474215d3f93de332207989e3eb22a9218d623f7483d"
    sha256 cellar: :any,                 x86_64_linux:      "f712e5a052d49f1b251fa20ac7be100fe51fb25f8e7c7a9b4a5526a225504cb1"
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
      cli_version = File.read("cli/version.txt").strip
      "#{cli_version} (commit #{Utils.git_head})"
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
