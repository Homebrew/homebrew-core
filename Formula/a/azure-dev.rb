class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.23.10.tar.gz"
  sha256 "779b169c5ac379065d21dff6e69b74439f2d46908bf0453c4dc6d83ece578187"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "994af7dce14edc877fd2fddb8398aeeb9c8a2c58d9b44dd812fdbcdef1b72026"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "994af7dce14edc877fd2fddb8398aeeb9c8a2c58d9b44dd812fdbcdef1b72026"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "994af7dce14edc877fd2fddb8398aeeb9c8a2c58d9b44dd812fdbcdef1b72026"
    sha256 cellar: :any_skip_relocation, sonoma:        "07b3dce133edc7775d72272e38b61fdcbcd803d2a38823f719a4917de8b272dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2783ad35eb519768ccbb80d39b6bf5abbedea6d99a6f21a2003a4363e109481b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d49fd17edbcde395775e21bafc407284dbef607ec66f2e74772e5ba4e13540f1"
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
