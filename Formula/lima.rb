class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/AkihiroSuda/lima"
  url "https://github.com/AkihiroSuda/lima/archive/v0.4.0.tar.gz"
  sha256 "482e4cff30103aac5bf93feb76721f1ada26a7618e503365040c4adae2a28043"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on "qemu"

  def install
    system "make", "VERSION=#{version}", "clean", "binaries"

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "bash")
    (bash_completion/"limactl").write output
  end

  test do
    assert_match "Pruning", shell_output("#{bin}/limactl prune 2>&1")
  end
end
