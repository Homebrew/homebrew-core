class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.36.2.tar.gz"
  sha256 "1d6b92b045eae3bc7c9c49cd2a998bbcda239aaa3fc3cbca3bec63dfd749408e"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fd4945e3ea9125a5c00e9e9c5e9d9e74c793c5d193443a31b25c04f3e38638c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79506564b9ca8dcb19709a83b5d3a628e7caf260f5d5c86be377e6b54e492ffa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "560659b0bca30058262b0de9be8e0c7093b8822c01d80794db42a3b7cc8c9a63"
    sha256 cellar: :any_skip_relocation, sonoma:        "88c42e851da0024293a4af6f2ef3ed0f47d9228d43983c506a1200d8f267957d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91a5c3878dcae16c39a63ec615d944fb1c5db3971b32aef1a86051a2a708ae6e"
    sha256 cellar: :any,                 x86_64_linux:  "e1142c65dfd1c350fc1de56a676b18138b48096ad7eae04738109129b2a0aaf3"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "k8s.io/kops/cmd/kops"

    generate_completions_from_executable(bin/"kops", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
