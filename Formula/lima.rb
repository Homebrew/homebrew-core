class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.8.0.tar.gz"
  sha256 "9a0162c88af76c8ccf8ce3919a5fef1ad3fafaf3cb6d9782aeaf56e69c8ecdd3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c1eac6ab5025a0806f8082050d7324ec1b09910668cf9aca5ebc376d4013332"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "562ee9ce2eb80b03f4681f7789adef7aba5400d73d3b99ff583aa215d251ae67"
    sha256 cellar: :any_skip_relocation, monterey:       "fcb7d410053198af6369f420f2b04392a21118cba19cafdfcfe059b9b37d21c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "873d331a5c547da3c86361d91a40fc742f01bd298847012aa5ce0c9d2dd19b25"
    sha256 cellar: :any_skip_relocation, catalina:       "5d99f9201dbf1c4293b1eec91d9041cde299148d5e2ad92023e7034aa4f7f980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b06669bb2ff9ed89ba00e0883ad6873239cc54f6f4eaae5e3d52cb5a21f2d09"
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
