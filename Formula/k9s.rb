class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.15",
      revision: "df613ec88d2d77d5b6e8804ceca959a544218391"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8aed4f6acb3ce6ad23b63a57d0fe17db8f5608102933184fad22490d69804d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e8aa376dc54d842813d2d8e3ff73037ccfb82a85757f4315a6abd558f55ba70"
    sha256 cellar: :any_skip_relocation, monterey:       "32e31205baa3f0d500517bfd3f3d776c1cbd74772924fb63b42eebf4231c1698"
    sha256 cellar: :any_skip_relocation, big_sur:        "beeee1cd692ee2f60e56c958f1849cc2fd27676aa37734be0f14fa11966fec1e"
    sha256 cellar: :any_skip_relocation, catalina:       "d94d00f927733f6d7542506f5fdb62d3633b097a0854ca26bce314885c4af528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b14c5c0a714136db56a91e8b09bab4676e5bcd33369fedc9cda50053a76da49d"
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
