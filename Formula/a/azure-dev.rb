class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.23.14.tar.gz"
  sha256 "163c94899142a2b4f3cd49ef1272ef4df6ac1b2d2c49af0ec661bfbc87050a15"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0519c6884346142792af180c460fa6c3702a4d289c64d699e292dd2c98283b3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0519c6884346142792af180c460fa6c3702a4d289c64d699e292dd2c98283b3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0519c6884346142792af180c460fa6c3702a4d289c64d699e292dd2c98283b3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc5b03e1ea346be1f8beb5e5b1cf0a8a7fe351d466a4a26577604a6e78a67d4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9349d10dcf0564e11c3042e33a7bf378d0f3fdb241ba41702879068ff20edd30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72ebdabd8f8be9a3947d448f6b2e98ab3e44b347576c143e28377e470462a08b"
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
