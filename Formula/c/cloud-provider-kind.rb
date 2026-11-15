class CloudProviderKind < Formula
  desc "Cloud provider for KIND clusters"
  homepage "https://kubernetes-sigs.github.io/cloud-provider-kind/"
  url "https://github.com/kubernetes-sigs/cloud-provider-kind/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "9a9dd366bfe121245cbc456f2b68b5261214299ffc911795bb67a386c5131145"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cloud-provider-kind.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c497e9ef00709e97cb72209c64cd596219077b8db62984f9cbefe544a390fe5d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9363d9263416f89282ebea7e0600f029bf6edb850a6306bb9d407b05b6ac53ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36767915314faf5005d7474fff9598c17145243986d4c50c283bcf5d0806baa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6bc741bd0a815a92b900d9b8001ad01420c3923d9c7352602ef013fa7d397c2c"
    sha256 cellar: :any,                 x86_64_linux:      "ad4e54319fab6acd45262717b14ce1b931ab14fe609c7a70b992cb21ca0b79e6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"cloud-provider-kind", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    status_output = shell_output("#{bin}/cloud-provider-kind 2>&1", 1)
    assert_match "no supported container runtime found", status_output
  end
end
