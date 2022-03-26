class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.9.2.tar.gz"
  sha256 "df0f84c7693e4f31ef40ccf209aaf034b96b3501ab2da8186c8857d372e5f0ea"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41f7cf37b3fa55b46884b355f3bc00d9885fc88dcd8402559475046c7ea98e1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03a2f7ddcf2f2acfb483a01c0cda74cce47b66ae4845d2aac39474ca8df185ab"
    sha256 cellar: :any_skip_relocation, monterey:       "62b108b56c46c065e987e072d1aa4dacb5febbe825b57c55a492f66af4e271fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbbb8e2b759d4585c157f530f9c55fd17b186b74616f45f60f85003f84bfb098"
    sha256 cellar: :any_skip_relocation, catalina:       "3e763a4c7131b342915b30c3ef3059efc739c62355e3c0b512d83f3a900f8732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49e9a8dc5cc1bef043bb4d7a7f0d28ec3748184785c0d03646d125358f299da4"
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
