class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.25.2.tar.gz"
  sha256 "346511cd7db1984e1932f2ed29b9e45cab7a47550dc3e08851ea5d642977eaf4"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48bfc69bf5fe102dd03df369e376bebdd295f7e216ef5f15419783ff73bb5d62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffd67ff997c84e36c8aa7ac3b5e9980b17624175e90910f6ee9883c3fd70df2c"
    sha256 cellar: :any_skip_relocation, monterey:       "f151541fccaa8e301eaf5c5e7c3b98bcd3414571b5d7b003bd9a65e87f094c3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b33124556aa9d385014a791ef27dae5ef7ed9bea8e9bf18adaa26a644b1f75a"
    sha256 cellar: :any_skip_relocation, catalina:       "824cee5a1500e0a9361af5aef146e2bb79eb61106f08df42305a0fb394fc480a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d189e8ebcd5cb22314450d4807cec26132bf41866d697583c8227c88070baeaa"
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
