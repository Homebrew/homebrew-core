class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.8.3.tar.gz"
  sha256 "8c23daa9ff3835bc47b187c47202ff95efd6a767f58789c11b2674b4ae0da403"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c07481474fbe5f640f565aa481d2ab04005483fb052e64abfea268413f00164"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ca4325ea866a28a5dac5e434a81e19e67cfa941af3d0f2f02050e20feeec999"
    sha256 cellar: :any_skip_relocation, monterey:       "4a57bf22cc1c412e84dc00ec5f9b79defb19d6009658e4c1fd242402ec41e235"
    sha256 cellar: :any_skip_relocation, big_sur:        "25a3df3a4354c4fa1894b022fe73bd83b57cd64eb6b20be3d71e8870622444ba"
    sha256 cellar: :any_skip_relocation, catalina:       "0dcfe564a79fa9f61ddaf30714bf7d8d50a58b090916072b2a8d507ea3eec9c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ba667b993ce0f724a546a0f622c062d162d5ef2b8a9e6d30d9c7c3570a9ae95"
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
