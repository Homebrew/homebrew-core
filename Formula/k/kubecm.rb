class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "e3be24b48d4205f098c2364cdea7e1abdc9aeb954961d646eff84a28fb1d4ed5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "38891a245dd10a2890f995781ea5190ad272785dc3c52ff6cedb764ea89cc72a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16c6cc2421cc8b70657f926103ad4227b6359e047241c2d9726a05657caf3f41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "071ac0f6a7a497b83267d183962e885b6d6c31db5e6edd801f86d127e18d3346"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06dbc8ddd9837102cae5fa1f0031ccef1a0dfba28221030f6501f5c5c3a97ecf"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef43982be9efc9725b7a62916ef368896a0943c9617f90f39636e07242d486e0"
    sha256 cellar: :any_skip_relocation, ventura:        "db6c470774eb5a648338a1fddf5ce9a304fd73224e0f9812618a474cc5509f71"
    sha256 cellar: :any_skip_relocation, monterey:       "78f3a41c5f398cb352555946703c6a08864816fec74f8e76d0510a9730d33843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d44d9545ca69838237196a8f02de6b2f9884eca6df4fb59e2ee3f6046a95c369"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
