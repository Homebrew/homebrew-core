class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.26.6.tar.gz"
  sha256 "306d1595264bee1d2b1fc5a4c732603659c62760083d8e1a97bc8e7773abc60e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "157f97e3525b2319202cedf4e8894bc6b016276b7f67af166e8297ab35905e02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3daae7f7be9bd1b74972f59d600fe69ad373bce729a2b37dc4e89fa64432a7e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28584daffa86c1fbc734ef57b62b0ba15ec384b53aed84fd74190b65cb1d223b"
    sha256 cellar: :any_skip_relocation, ventura:        "256f482170c118a2b539971fd4dd855656ae187e1eb23ce743e902f4228d86d0"
    sha256 cellar: :any_skip_relocation, monterey:       "1a2afc65eaf4a7454f4197560ca974b767d416f727500ccdf3f7aed6a5575358"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fddfe561e6db84a1e938247a2608cf2488ca11fa4bf54c42ec72370ca50e5c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d436fffdb221acaf875f863043d0b1c16f0e6d8ca6f15f58ae3320f7b71b8759"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
