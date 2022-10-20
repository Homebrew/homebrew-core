class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.12.0.tar.gz"
  sha256 "d3b04081d6712e6463df447b49afb08ceabba9b22e98a4cc82dc3a494ea47cf0"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c8000d6bdf853701b11e1fd297c7507a9ce656b836103c23d5f3f5aa9632dfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45db39b65b84147b38ed3fa0224040102185ac7ce33bb69868597409672760de"
    sha256 cellar: :any_skip_relocation, monterey:       "0c9c6157720b74c1874d782d0d736c310d3d60f127021d6f7346045faf374508"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddef4c196b1d7e9755f58072446ecc81ef66e4844c721cc5665eeda58e055093"
    sha256 cellar: :any_skip_relocation, catalina:       "f9e9044da35ef7b74f4eaa18365f0bcad73b6dc412440c4d56c5a9f862612437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e9b4e2887089918735e257b71da8c8467bcd41069d20e7c6fa1bce37a49d157"
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
