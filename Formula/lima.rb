class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.11.3.tar.gz"
  sha256 "562166d1266013bd434444edb8c12b53a9fe7e4a36f5371ac9269d87b173adc1"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1d94b3fab9e20cbb6cc3be2f9b8681aa9af432515e47cd6e28d4fc652670d04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "304d4c1434678c4fb958b22bb04086e25018d7a9e9866501fff223b95de199fe"
    sha256 cellar: :any_skip_relocation, monterey:       "2ed0d377f31ed7e1448098dcaf07b33303c2afc9615a140261efed037bde773f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddf61fd17410b83e9b6540c61d601f71660f8360dc0b1555b47edb982b177dab"
    sha256 cellar: :any_skip_relocation, catalina:       "827fb3183a3407b53a500a5b5904755c16b2bac7fddcb93e73493523a202b0e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "262c98e0e6eb48ac230eb1818fc5fc916bf27598bf622bd8eba3036a40c41eac"
  end

  depends_on "go" => :build
  depends_on "qemu"

  def install
    system "make", "VERSION=#{version}", "clean", "binaries"

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install shell completions
    generate_completions_from_executable(bin/"limactl", "completion", base_name: "limactl")
  end

  test do
    assert_match "Pruning", shell_output("#{bin}/limactl prune 2>&1")
  end
end
