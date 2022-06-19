class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.11.1.tar.gz"
  sha256 "72f789b72c370f7ce1f16db4a34e68f6c740e8dc4584596dcc75999dc7555ca7"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48f163f32da28e604e0185586ab3b0d58d03ea08dceb5062a3eea8b68708451b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c86f1bc99d8d2b404928c8976bad2ef8743f3cba1ca3a6d866acd94c211a8a3"
    sha256 cellar: :any_skip_relocation, monterey:       "d1c28afbc17be50e1465336fc1f1ceded322b6a8946b9716f61c5c098cb531ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "34316d34338c4a90f540a4ff1feb55872f1d6451fdb794f07381270d17ec68d9"
    sha256 cellar: :any_skip_relocation, catalina:       "aab6e17a985581d5daba4814e149d84fcc1e665913e4b2087a623b51ad2fb8ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb753cfde774ece5b9c4ecb104fdefe46d0d901096a517b0ac8fe492f1b754b4"
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
