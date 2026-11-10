class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.36.3.tar.gz"
  sha256 "2eb48960da215b1cdaab1edf3ee079509b9564390af07009eb47ec259c018fe2"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bbb99cdd392b63464e96da1823ba47163541f638d8181d9a28515a7248d839e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a14f45ea1d77466513562b2d60872e3659a1ca27df872d613be54bfb0fe9639"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "67de2b1f7f620d6b77011ddb8aaa5ee5a9ab78da27e15c52247b96b9350ceb8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "abc512145c29de118833913c666430d172c984cdd6316922fe88d017f7050306"
    sha256 cellar: :any,                 x86_64_linux:      "d37c2ee6c03de19a291d95e435a4d02fcd3dcb2ed786de583ba11237c0faea43"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  deny_network_access!

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
