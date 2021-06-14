class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/AkihiroSuda/lima"
  url "https://github.com/AkihiroSuda/lima.git",
    tag:      "v0.2.1",
    revision: "4ccd40976296a8911ad84fddeff82bb9c2d754bd"
  license "Apache-2.0"
  head "https://github.com/AkihiroSuda/lima"

  depends_on "go" => :build

  depends_on "qemu"

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"

    ENV["GOOS"]="darwin"
    ENV["GOARCH"]=arch
    system "make", "clean", "binaries"

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "bash")
    (bash_completion/"limactl").write output
  end

  test do
    s_output = shell_output("#{bin}/limactl prune 2>&1")
    assert_match "Pruning", s_output
  end
end
