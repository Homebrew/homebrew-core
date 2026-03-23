class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.23.11.tar.gz"
  sha256 "62a538a079c0e6cf14d9523fadf3c3ce688899b550725e232ded05c05b7506cb"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9438f3376adb5751f834cdc524c63e9642f1cfa95bed4a9322b432cc62eb1d03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9438f3376adb5751f834cdc524c63e9642f1cfa95bed4a9322b432cc62eb1d03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9438f3376adb5751f834cdc524c63e9642f1cfa95bed4a9322b432cc62eb1d03"
    sha256 cellar: :any_skip_relocation, sonoma:        "43491e5ce56512009823881c0f4e17d83eb4dee5fc0f512254079ed1f4e63de3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6478d49ce43a33e076e2507205d13e42f248cb025058382aa49e413ba067c61c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd9e55ccc4edd89c5a3e3d5b45733173e0b5938fe8b443d75da00de84ae10d0f"
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
