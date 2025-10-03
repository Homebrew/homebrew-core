class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "68bb4c60c4574309170db916af07e5b04df67afb3dd5e3d0d34d2f1a52196396"
  license "Apache-2.0"
  head "https://github.com/sunny0826/kubecm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2081fa3c068c0677440fdde545804af28a39ba2054a45c49b088ba9e7cc0aca7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c51fbb3083b295f06961456070cbecb9e4bd98771ef175ee9146a6b5e97a6190"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c51fbb3083b295f06961456070cbecb9e4bd98771ef175ee9146a6b5e97a6190"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c51fbb3083b295f06961456070cbecb9e4bd98771ef175ee9146a6b5e97a6190"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d61ddf8bd9166e502ae088f4d0ac02f1f03498e529d5b01a8b1f9b0ac0ebd53"
    sha256 cellar: :any_skip_relocation, ventura:       "7d61ddf8bd9166e502ae088f4d0ac02f1f03498e529d5b01a8b1f9b0ac0ebd53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f411c58816d4ced391cec7df8677fd7e5415ff245d027330a3d2b64652a92fff"
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
