class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.8.2.tar.gz"
  sha256 "03bab7f17078e1d57c0122eb68acf3a19bf8f6f37397a2730b89d87bd9bdd4dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb374b15373ee9f028f288e34ad49048aaaa7ee45ed8b83887787b5d2d4a05c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9a759b7a697ae4e87cd384455651d719be277ef77dfa0561c3d0a669ae70ff7"
    sha256 cellar: :any_skip_relocation, monterey:       "12f7990864d9f21fbd438b696b76e9d86b58d0536cd82d780d4d389fb7f43379"
    sha256 cellar: :any_skip_relocation, big_sur:        "20d0b7a95a5ed53c32f3527ffddd640876a9d036d63cb2936daca56d4236845c"
    sha256 cellar: :any_skip_relocation, catalina:       "84007dd2066c5de2b626e3e9d83b3fff8b3464b52bd703fee6c8dea2154f1bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0cab7ca1f5c537f179385186d491bf29d339d9db5dab2fc12f1f1d33fb8ef2a"
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
