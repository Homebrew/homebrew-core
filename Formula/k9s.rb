class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.18",
      revision: "6085039f83cd5e8528c898cc1538f5b3287ce117"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fabed8c642a6242e1e169b774f450c3a1206efdbd4b8dba6927ff73db8c65135"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4073ea13ff799d8ee9beaf78f32050895b4f67eee630ca2c1e91188e8e373f9f"
    sha256 cellar: :any_skip_relocation, monterey:       "c869f9a76bb60f92bb3cdd11dabfa239381def0bd117b5395c7a9c70bcca9e5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f341e0a3c66071e280207a46716a2b354f784a253539960d4335118ba4328537"
    sha256 cellar: :any_skip_relocation, catalina:       "424a41b797240daee6ba710c63c52d062b47a9b987a566bb5e63e17b6a6a7cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "300598cf8c533553ecef66565215384980b9cf8187e66cca4ca8cecdca4f8fb4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_output = Utils.safe_popen_read(bin/"k9s", "completion", "bash")
    (bash_completion/"k9s").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"k9s", "completion", "zsh")
    (zsh_completion/"_k9s").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"k9s", "completion", "fish")
    (fish_completion/"k9s.fish").write fish_output
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
