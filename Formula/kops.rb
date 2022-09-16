class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.24.3.tar.gz"
  sha256 "440330c21d8898ea7091283dc8334b8ea93195c4bdad238cf209da8aadd996f5"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9a0c8f692acc8db274e043d35f4eedf9d4e34e38f6055a25f5873b411e5ba60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47a65b309e0dc21676c1f784a05c78fe71a99b6cc9ae7e9be453c63992a9c868"
    sha256 cellar: :any_skip_relocation, monterey:       "00fd02e6575cf3dc086b0651684b9f218e82a25253e49a064c0c646625a4e3e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1834c3c42f0c5a71bcb46f86efbb4ff732121a84f0221d172ea1ed8cc6aba84a"
    sha256 cellar: :any_skip_relocation, catalina:       "067a6b61b149d9808cb1da531bdbaecebab11bbd104ebee192c59cec9afbd45b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3a44a25d9b2950ff03fd25064751fb100df0b7aec20c0bf1d17e61ad5b4e0cf"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "k8s.io/kops/cmd/kops"

    generate_completions_from_executable(bin/"kops", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
