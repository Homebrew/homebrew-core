class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.22.2.tar.gz"
  sha256 "b6c80827d9a2562743e6b88e23f5ad21bf80d3650acc6dc6009fcc0b3d42df0a"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "728f7a598585765379e2c610a64c096bf7d0cfee1e807f1ad2d061c92f6bd207"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0905301963a7533d08b0f549f998165de0cef54f738215e1fe7b52e8ed172769"
    sha256 cellar: :any_skip_relocation, monterey:       "1bb3648c8bdf1654599601cb8460e8ca87db4326010825355f7c1f2227333564"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8064049597a3b10d43940bacd1951a69bddc31656a09e257700711a0530e22e"
    sha256 cellar: :any_skip_relocation, catalina:       "826ebe6554810b9e853fd082acff0c40110dd431e36f362e2e761dde1d2148c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81e76844338bff74f110bb805f2d6522554d8b0e3dc47376144998023d60fb3e"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["VERSION"] = version unless build.head?
    ENV["GOPATH"] = buildpath
    kopspath = buildpath/"src/k8s.io/kops"
    kopspath.install Dir["*"]
    system "make", "-C", kopspath
    bin.install "bin/kops"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"kops", "completion", "bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"kops", "completion", "zsh")
    (zsh_completion/"_kops").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"kops", "completion", "fish")
    (fish_completion/"kops.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
