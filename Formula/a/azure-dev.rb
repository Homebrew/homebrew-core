class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.27.0.tar.gz"
  sha256 "e7bce05b046016f58649e8b526a8b6e35746f9abdae1c17198c778f6f4e5fa01"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0510ee4b2bd628f3e66a63203b92dfbe4560f6ae6de071194af73a879595405b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0510ee4b2bd628f3e66a63203b92dfbe4560f6ae6de071194af73a879595405b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0510ee4b2bd628f3e66a63203b92dfbe4560f6ae6de071194af73a879595405b"
    sha256 cellar: :any_skip_relocation, sonoma:        "75bf3bbd956785608b09911aa6d2cab0dbc6b7a5148af49c96fa8740a1a1f16d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e7785d9e40b929ea3fde32a736c902a026603cc4894b9c78500d18eb358879e"
    sha256 cellar: :any,                 x86_64_linux:  "02bf74c7098ece05dbdc186d0cb6c43841ca06fb1eafb027210fc02fe84ccbe5"
  end

  depends_on "go" => :build

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
