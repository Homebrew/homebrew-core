class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.25.5.tar.gz"
  sha256 "e90882286d5a400dcc3a360389994c12548948103f24f7eee400baf1be4cd502"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e649cbde6b81df3d68f9a4f7f24d6ddcaa27486a46e530e2e89a122ce9c3bfb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e649cbde6b81df3d68f9a4f7f24d6ddcaa27486a46e530e2e89a122ce9c3bfb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e649cbde6b81df3d68f9a4f7f24d6ddcaa27486a46e530e2e89a122ce9c3bfb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0480dcbf63ec1eaeda815bc2386e915004a8250ed7f50306f04ad74d9cf486b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "162fed792bf4cae71128532988759b093c9f3471ed0dc1d82e4179b5a659162f"
    sha256 cellar: :any,                 x86_64_linux:  "3212e5ca1fa1fbb2e57b1f50e31cac578baffa482204a02599201d49851ac378"
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
