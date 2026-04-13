class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.23.15.tar.gz"
  sha256 "9ee0a898d16cd344c9cfee49c4dc6dad0ed305cbbfb87ffb20c688a51bbcbbc9"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4229507534dfd47301bc7cc40d3e841f8ca96ec206d7e0ab39bc36a54e599772"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4229507534dfd47301bc7cc40d3e841f8ca96ec206d7e0ab39bc36a54e599772"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4229507534dfd47301bc7cc40d3e841f8ca96ec206d7e0ab39bc36a54e599772"
    sha256 cellar: :any_skip_relocation, sonoma:        "3002d6f9cbcb56959c143494a0b64314937e8f13e631366820f83a3b9f5a25c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68982e18d905b2f1a33d03d8b719060286861eda1ca5887cba4c9b9fc766b228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ce6e3e6544dde54a150bfa2d9294fb8c4e42de8b40ae4fee77f00fe76d7e822"
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
