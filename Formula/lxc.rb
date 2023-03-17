class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-5.12.tar.gz"
  sha256 "6061ff3346b0e7ab2736ddecf1dadc2581d93d89155bdf77622945db6f27321c"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83a79e7445fa074157c9c29da3648f85719a5ae4ea413f548eef53edd5e6df16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a172458b7230af243c7e9c97a965cf386f271796fbb882174463b5e3b29eacf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45401288aa24ce3d0793b5b25e4392fe7d62a870b88c2a2392d239db058f5f93"
    sha256 cellar: :any_skip_relocation, ventura:        "54436f233d7854ead99671c59e2605be434d9dbb31a31bf6c13108e3c9408646"
    sha256 cellar: :any_skip_relocation, monterey:       "65dad2045f53e74c0a47d6c1d1df9f8fd82fc54aabcd9a7dee93df826808674c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1affb0486e43d06bb2f5096efe7a51b58acd17257013e5d5868dd034fa6a2bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f29cb392bb2d835babf5b4fa59e82ca99ee26dd9044acb34dbca4e7d12f12a7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]
  end
end
