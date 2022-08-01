class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.24.1.tar.gz"
  sha256 "011c01528e5906e6d4ffa4371f9f855b8fe8c635f67a056eaeda0b02f8050e92"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c374e1292d81c9135e49614ec50bde758ff7c80b770983aea1d507017b51ac25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d13e10beb26dfb730828c158bac61498fd3316b9a60c5cedc7ce02bc1f3e052"
    sha256 cellar: :any_skip_relocation, monterey:       "94b31a11d3bdf7cf81217031293a48034e9d5c0d03de9b0757d2c3b14fe6a9db"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9d0d28cecbfe9c2c21a10e3eb09a3497542739a3ff9c3b4dabc0c6398bf2f82"
    sha256 cellar: :any_skip_relocation, catalina:       "7513c722df0b3535c2a21d16e6142caafde7f8b3cd4966e1e29a8dc72db58c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c824a77310fe4e0919433250f16aaa5c80d20780eb4a718860e8dac41c4a280"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "k8s.io/kops/cmd/kops"

    bash_output = Utils.safe_popen_read(bin/"kops", "completion", "bash")
    (bash_completion/"kops").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"kops", "completion", "zsh")
    (zsh_completion/"_kops").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"kops", "completion", "fish")
    (fish_completion/"kops.fish").write fish_output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
