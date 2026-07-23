class AzureDev < Formula
  desc "Developer CLI that provides commands for working with Azure resources"
  homepage "https://aka.ms/azd"
  url "https://github.com/Azure/azure-dev/archive/refs/tags/azure-dev-cli_1.28.1.tar.gz"
  sha256 "28a91784a5a4eeddb867df6b4aaac3d855cf8ce6aebe04ace8196bf3f5154dbe"
  license "MIT"
  head "https://github.com/Azure/azure-dev.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35e323fa6e43b3df1244c4e2f750fffc4cddb8b855bf9b1a36db8561af8f7559"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35e323fa6e43b3df1244c4e2f750fffc4cddb8b855bf9b1a36db8561af8f7559"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35e323fa6e43b3df1244c4e2f750fffc4cddb8b855bf9b1a36db8561af8f7559"
    sha256 cellar: :any_skip_relocation, sonoma:        "d63254635a5b9363213ef3f28c57b061c8a040c0be52f67bde32b2854862b4ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3d38562d7bd121d6fa8b6508beca190c28452dd114b562dd80de7a2f0c33957"
    sha256 cellar: :any,                 x86_64_linux:  "e5889b3c2b0e2cd9672db106e7ef23721afbc94ee3ef46b124be12a133efda7a"
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
