class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/refs/tags/v0.32.2.tar.gz"
  sha256 "54aaf537580018ad668af1aa02838c8e8dabc962c734460a06be02835fb6c241"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dc5ae00b3513190cfebcc2173588f2c54582b9dd6bd8bb1802503780da1594d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dc5ae00b3513190cfebcc2173588f2c54582b9dd6bd8bb1802503780da1594d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4dc5ae00b3513190cfebcc2173588f2c54582b9dd6bd8bb1802503780da1594d"
    sha256 cellar: :any_skip_relocation, sonoma:        "32e7e7ec8f257b21b7d8c7ab3d26947e8bb6ba5a303827be4325a98b5ec5b9a8"
    sha256 cellar: :any_skip_relocation, ventura:       "32e7e7ec8f257b21b7d8c7ab3d26947e8bb6ba5a303827be4325a98b5ec5b9a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5d97c89eb7838d2098927a62909c4802484ada82b4f07a0acde066b0c5ef623"
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
