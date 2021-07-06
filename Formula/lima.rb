class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/AkihiroSuda/lima"
  url "https://github.com/AkihiroSuda/lima/archive/v0.5.0.tar.gz"
  sha256 "2fc3764947d3b8a51f61ac4eeb6160a737f0f982d68491916de7b398f0f43a67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62efeacf2b93d8682f5d5484e9fddae5375c6bbb4b79a4152b84f7cefc4801a9"
    sha256 cellar: :any_skip_relocation, big_sur:       "985f4cac8603f1f84ece40cdf5dff7c855db7c92190df8aaebf3c2e0e0f047c7"
    sha256 cellar: :any_skip_relocation, catalina:      "ea3b36d9be47834c2b57898b75e4f122e9ee9066b3226adecdf3eb2a2836e149"
    sha256 cellar: :any_skip_relocation, mojave:        "6e78a4a150b2c0043227bfa008bad25308881b9174e432cb08ee6d64cd5818b3"
  end

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
