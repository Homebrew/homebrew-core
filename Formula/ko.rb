class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://github.com/google/ko"
  url "https://github.com/google/ko/archive/v0.9.3.tar.gz"
  sha256 "a31c9f6f3fd443599b854338f396f0e4c43a3d6ef7b1138f5df75a2c1c785c61"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e660aae5d3e7df1cca605319716dd9ec5ef5b6ba1f2cd1309d891f597e3849f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a5ee4a862a5328cb8bc2ba75f1ac576ed7bdfced22a37aa823dccd0d6653ee0"
    sha256 cellar: :any_skip_relocation, monterey:       "094e53771b71110f7df68973e84491adb465799f88655f11bc64276481902d8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1ab2b90c847b8ebcd4225d21a604c60eb0e7e4cf236e21694d4d8bf6f7d5d9d"
    sha256 cellar: :any_skip_relocation, catalina:       "5d9c6dc8c007b469f2db46730d100e8b5610da54c574839d2e10ad59aee1911e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deea93329a7fcc6f595ca491a25091d8dd78a1cb9c8d743fa074a7d3222b787f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    bash_output = Utils.safe_popen_read(bin/"ko", "completion")
    (bash_completion/"ko").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"ko", "completion", "--zsh")
    (zsh_completion/"_ko").write zsh_output
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
