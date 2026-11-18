class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.39.1.tar.gz"
  sha256 "a40439fcc3f9777e84e058406ad633a4df1aff5c3e6fd93fd0ab84f2fc2b405e"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9bc69f2e892f484f1bc2d752487f2935fb867a14c69e94855ebebfa9e0e91383"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9bc69f2e892f484f1bc2d752487f2935fb867a14c69e94855ebebfa9e0e91383"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9bc69f2e892f484f1bc2d752487f2935fb867a14c69e94855ebebfa9e0e91383"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9a2bd2e5e0cb0f8e7e0b75e2f955aecdb106483689406545ae864dd4cc3114fb"
    sha256 cellar: :any,                 x86_64_linux:      "0620ec56bfea46a30541776e84ecad44a7966e38561899e70bc90b6d5a1a5bd7"
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
