class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/AkihiroSuda/lima"
  url "https://github.com/AkihiroSuda/lima/archive/v0.3.0.tar.gz"
  sha256 "0debed5cd2fcb34ce90114c4f07a3610a3b2d4aaf4592608135e9053cb5ce213"
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
