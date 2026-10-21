class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.37.0.tar.gz"
  sha256 "83c9eff702b5ecbdedf6d9861c7f22b3efc0077630beb909d7a3162aad89d891"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "682825c17b9902596db5015c842cbc12977197ef74a2c08dc0f692def752ef01"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "682825c17b9902596db5015c842cbc12977197ef74a2c08dc0f692def752ef01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "682825c17b9902596db5015c842cbc12977197ef74a2c08dc0f692def752ef01"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "54cff9be40165dbf688b7bb1d2fc67ef70b9ce5c9652eb71ed6c982dcc140d34"
    sha256 cellar: :any,                 x86_64_linux:      "216176bcc2986e95930c735441a6994abc55cfe5246ee0febc855bb7d6cd322b"
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
