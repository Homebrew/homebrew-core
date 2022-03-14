class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.9.1.tar.gz"
  sha256 "fbf7d8181c7c9b1e12c4db017acd72b60ff5e34ed9df0fc40a767a17261ce50a"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d3b0346a25af72795b616858df16ad511a946e8e63b2308885883542f4928ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ec75bb007588f14fbabf53ae1906e3732c4d1bd75b64f9cd557281cba5cbf94"
    sha256 cellar: :any_skip_relocation, monterey:       "4e87b30ec6f63bf786d34a0bcfc9b0574db143921ac5736c5ee00cdd785fcaed"
    sha256 cellar: :any_skip_relocation, big_sur:        "377dd6a306e528d521b8d1153ba75a931852df7ffad2327ca29b56ffd60a23c1"
    sha256 cellar: :any_skip_relocation, catalina:       "d764fd87f6ffe79e3e3ac699e9733b5b83ee9614a6bb360e44d643b34ac444ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4bc946f292fd7b28213740e611890783a367358dc28b82493c2d45c1d5451a0"
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
