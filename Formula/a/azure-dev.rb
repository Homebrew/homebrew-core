class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.31.2.tar.gz"
  sha256 "7039fcb1696497f84972a21b282d3889fd60113bbf097767b71c488be8ca13c8"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c519e068479b9b70f889ddea77087f9e4ce139d85098cd88102d1ee29f1c89b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c519e068479b9b70f889ddea77087f9e4ce139d85098cd88102d1ee29f1c89b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c519e068479b9b70f889ddea77087f9e4ce139d85098cd88102d1ee29f1c89b"
    sha256 cellar: :any_skip_relocation, sonoma:        "543870f5952fe7bbcaf715f50db4d45441c069995dd7d7252df3b6b6214b7fc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1565f39732851876e6f7b2fcd71c5dd8bb60bd61544a3d23fe8230ce459ee6d0"
    sha256 cellar: :any,                 x86_64_linux:  "b2f4be842c34609673a48bfae80d838ea0f02c45f278b0a25654c82087319ea4"
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
