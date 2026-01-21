class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.23.0.tar.gz"
  sha256 "279e021ac023fc37b9d2943ffbc517db8e95d681d6bf0192ee5a35277149796c"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d73ec4e9208607e7138421af9da854c14b753c234d6600bdeae6ad149b3ba27a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d73ec4e9208607e7138421af9da854c14b753c234d6600bdeae6ad149b3ba27a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d73ec4e9208607e7138421af9da854c14b753c234d6600bdeae6ad149b3ba27a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8e3c109f9ea1599ae460eb02d62f7d7cab79b1b6f3a20a1b0eac7fd15b3dbc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "181646a25f915c07296a81844e9859adff33a4b99a39fd130d63246fc6335a34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e79eed8abba27866f58cbd4fe2c1a831e08fa43dd5326da708610d2938527be"
  end

  depends_on "go" => :build

  def install
    (buildpath/".installed-by.txt").write "brew"

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
