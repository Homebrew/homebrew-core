class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.37.3.tar.gz"
  sha256 "8d7e6f8436147a4f94e5435598331ebdd5f134d719d4d7016bcce4d6253c680d"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e54e030972491a046d51912064376aeb4987bc7732d2a9e0037331286185e931"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e54e030972491a046d51912064376aeb4987bc7732d2a9e0037331286185e931"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e54e030972491a046d51912064376aeb4987bc7732d2a9e0037331286185e931"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d3b84cf24e890b71be40b1e2386aa34b09b63e3258fef8951d5aa6cf7077afc9"
    sha256 cellar: :any,                 x86_64_linux:      "0be2db8bd2ff44b7fe5485a064d5e4c45ac3f359a3f0ac9c6acc8462fa010748"
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
