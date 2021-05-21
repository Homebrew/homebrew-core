class Lima < Formula
  desc "Linux-on-Mac - macOS subsystem for Linux - containerd for Mac"
  homepage "https://github.com/AkihiroSuda/lima"
  url "https://github.com/AkihiroSuda/lima.git",
    tag:      "v0.1.2",
    revision: "41fd9cc6a1e2bac73666e1f2b11604c7c42227dc"
  license "Apache-2.0"
  head "https://github.com/AkihiroSuda/lima"

  depends_on "go" => :build

  depends_on "coreutils"
  depends_on "qemu"

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"

    system "GOOS=darwin GOARCH=#{arch} make clean binaries"
    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "bash")
    (bash_completion/"limactl").write output
  end

  test do
    s_output = shell_output("#{bin}/limactl 2>&1")
    assert_match "NAME:", s_output
  end
end
