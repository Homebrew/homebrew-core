class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.22.3.tar.gz"
  sha256 "76fb2e20f1d4d54904311c3aec2298ae99dcea5ea8473677a61f6e6c7418d341"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3752850aeaf6cc5e9c53c1468b8ae11e217d70924b694b04b746e20185662c5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7842488ff656cd654ffdec35424bf6d7c4bd4056ac7a5ce26809e10faf3e6f48"
    sha256 cellar: :any_skip_relocation, monterey:       "93cb5b6996eba7971a3cf56c9c0c69a01445b8476c14e0f165a77b6924ceb06f"
    sha256 cellar: :any_skip_relocation, big_sur:        "043c467249b09b131fd3ac4aee81629784443b1e7bd24a6ed378d3f773c635c5"
    sha256 cellar: :any_skip_relocation, catalina:       "ffef55a99df35664f866ade365867e4faac3eadf200585f1e439072bc42c10cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4aeb48d2eba43c908951c271047e8dc203076f49f36c6a997a9964f75c20141"
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
