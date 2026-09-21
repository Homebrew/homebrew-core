class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.34.1.tar.gz"
  sha256 "ba65e9f2b3d7a1d1e3ea8b1048c717e8f2ec458545870cc7bcd8eaf6f752e741"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ae14779a8d8992a6a77900de30cebe9b4ed6d7b6186cfef0bde111b4b97d2a01"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ae14779a8d8992a6a77900de30cebe9b4ed6d7b6186cfef0bde111b4b97d2a01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae14779a8d8992a6a77900de30cebe9b4ed6d7b6186cfef0bde111b4b97d2a01"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7c30540937e2d11a84b68f77c230e145d4ffb7d58406290dd9e63792a092e39d"
    sha256 cellar: :any,                 x86_64_linux:      "041c81e6683abf751f9ae695c1711909f198d99e3e31d52c569c80b965f22256"
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
