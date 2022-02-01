class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.8.2.tar.gz"
  sha256 "03bab7f17078e1d57c0122eb68acf3a19bf8f6f37397a2730b89d87bd9bdd4dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64f787219032789fa071ce9c624e8e561fbdf2c1f74255dfb1072dea6e467f22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99e773349f4023aca00b54c1adf83d0f33fa603d09c3a2f5544111c7c1a75b7f"
    sha256 cellar: :any_skip_relocation, monterey:       "546849843b59d857373fde459445278b1845f97e9366e77bc3b22dab413ed3e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e16e3bdb50593a99fdef4da52ae710541d82e0739379b127a693265744d7565"
    sha256 cellar: :any_skip_relocation, catalina:       "c382beb7096437d60fe563aac839c72eab6130799fb23215e764f1d4821b37e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d64811588c729cca1c7824dc70985d48183ae3415c28d0df952acbb5fc3f2ca7"
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
