class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.26.0.tar.gz"
  sha256 "b0ec2d95aff69b89f9261afd59aacba8d615c5d18b6356a244472eb82f3e40d2"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1581c3ff2b9c4243306fdf20e5e69af7a9f6eb4e4260eb9f0d557c9542cd8fc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1581c3ff2b9c4243306fdf20e5e69af7a9f6eb4e4260eb9f0d557c9542cd8fc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1581c3ff2b9c4243306fdf20e5e69af7a9f6eb4e4260eb9f0d557c9542cd8fc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3958d8775228a4d9bdea9befb839f41e8784a8f4958fd85f33365569c277d20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bea3dfcf20cbde60e7213a40c32c7b7d6456b63636414034613e3b17651f1316"
    sha256 cellar: :any,                 x86_64_linux:  "301aa0e972ec6f10714c14436f5f5354cff38211f8a391cd7028b7d3429ce88e"
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
