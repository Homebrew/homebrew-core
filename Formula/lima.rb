class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.11.0.tar.gz"
  sha256 "b4f89cd8be84d2530a9ca86544ee9709b6d90c50ea0a08bac5959813f4bd435d"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca916c6ac8cae0ad74c730f0227e09047f1382e8c349e99e46bae87f9100e4fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4bbddafb74c01bd059b07e225777214d27852220ea0adf81173ce2a15cd9540"
    sha256 cellar: :any_skip_relocation, monterey:       "5d45eb0167b48b0a1cf1f6ac53c8833bd0fb00ad9d43489e27a9e2aff061cf79"
    sha256 cellar: :any_skip_relocation, big_sur:        "06c850777a94054281778a078d84967aa7b49510420afb0bde46ea795a27a8ef"
    sha256 cellar: :any_skip_relocation, catalina:       "47e1f40f277cbcdb7d996ac036fe6b7a1152c34abd31a343e46cee5d81b5589a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14ac2ac6b3965f0946f93e85b7601301135beac4a351a27bb87ab1f6c7462541"
  end

  depends_on "go" => :build
  depends_on "qemu"

  def install
    system "make", "VERSION=#{version}", "clean", "binaries"

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install shell completions
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "bash")
    (bash_completion/"limactl").write output
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "zsh")
    (zsh_completion/"_limactl").write output
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "fish")
    (fish_completion/"limactl.fish").write output
  end

  test do
    assert_match "Pruning", shell_output("#{bin}/limactl prune 2>&1")
  end
end
