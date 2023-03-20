class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.26.2.tar.gz"
  sha256 "01d1af58b3cc2ff0917aa0ef95c7f1761bf3572b90e48608637771c2ba779813"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "faf461bd60fb3d258e0d4018e327863b4a750c24bde20ca09d7f9fe6a4fd4c17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b07e6a57c440db9821a88fc399835bf36bea87682c308a47e7204cc10264c8b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cc622e8e691efaf1137bc76b632ab1748eafeddea4479b081c7f0b2102bc5da"
    sha256 cellar: :any_skip_relocation, ventura:        "fd7748a6908cf51402379e7974cf4b1a873e0cb3a66b15b14b52db8eb535b1b1"
    sha256 cellar: :any_skip_relocation, monterey:       "d3feded19de20912de869630f00e4c6df2f66ceeaacd9015556d4c07f5f03da2"
    sha256 cellar: :any_skip_relocation, big_sur:        "59fa1e8998495b69df0219f2ea500b81d4b1c50772e75e7ebcb0c8a5fff32e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba7cb94ca50cf2d015db7b09a62bc19d9a61ecbbdf436796291038374541cf87"
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
