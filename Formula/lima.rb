class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.11.0.tar.gz"
  sha256 "b4f89cd8be84d2530a9ca86544ee9709b6d90c50ea0a08bac5959813f4bd435d"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ead65c28776d268738d2c609657cd297f5b3c6d02f4295f6f798e91e38249c09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b53bb5c93a77096fc714b83fbfb7b1627e5b7240fabae2f83a1e6b7d43b8e552"
    sha256 cellar: :any_skip_relocation, monterey:       "55fc8683194596963af16021c1063e8b79fd5f215505ce69100ebcab1ce8e84f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7816296f6a8770fb193abeffc2efef6b28b963d0ebfb4ba031b071909426c64"
    sha256 cellar: :any_skip_relocation, catalina:       "77c1e59c5990e90aa62f3b577ed087325aa9603a9bacee752d5e34c6b355f3b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f39f2fd88a79b6d073f2652fc799557c1e42459aee9e0b80364b9255abfa491c"
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
