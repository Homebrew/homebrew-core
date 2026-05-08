class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.24.3.tar.gz"
  sha256 "cdaa4588139d892e8c05f2bae13a67ca085d2a4dcde321b513d639efeb19a597"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcf5cd23c4afeb7bd342d6c24a601d8ac0fe9d3c7c45726611458846679e4cbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcf5cd23c4afeb7bd342d6c24a601d8ac0fe9d3c7c45726611458846679e4cbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcf5cd23c4afeb7bd342d6c24a601d8ac0fe9d3c7c45726611458846679e4cbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ed2039aad792410e8fda83c539fbab6c63439ab2ef302fccadf4466ad00c0d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ac7c19564fc547a050871a18b4df30fc78f2959b25db5e8710142e73cdbbcf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82501e55947562e93359dc13d3e5d0350c50e71fd56c9814e31529619c52a530"
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
