class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.14.8.tar.gz"
  sha256 "30a5949cf5d0f8ac26115b4347d4bc5d7020f683215738d70dbaf0cbe21b14b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dce7afe4972f03578d780a3a66bc3651e5d73576aff6ae6ce730a2bd4db03dcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0dfb5fca0eccb7ba0e60be589d2764990a2f6070e558a922fba9bc8f5cc84bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41165ea83a79c47545bcd64bcf29163a2e7eb56fb52f86e32c2f546ee51061cf"
    sha256 cellar: :any_skip_relocation, ventura:        "5ce33ce7aee54df6e4890d706ff9198ecb23a7c44f43131a2b2de52e429e4a9a"
    sha256 cellar: :any_skip_relocation, monterey:       "37bb30b1899d6ba89a095b1a2a33afabc43f23f28e57422ba3b086ea4133a3da"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a744d7fbfeb6a3fa37ae07c764e46a3824a0903775471d2d9c41c98c00ec2f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bd50e62c8fd67ef7e3cfd1a74c08c2539229442e0bb399ac40a514fd315bb1a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/cli.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version 2>&1"))
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
