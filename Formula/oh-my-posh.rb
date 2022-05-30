class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.94.0.tar.gz"
  sha256 "262198ef5ee88d213422f80609c52f4ff866ed0a24aa0a5ab6c3e05d036fbe55"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e77b20b17bef7bd99d731f091643553d1fccdaf12eae5548250bbba22d77fc0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6413fa67de3c7e51204060acb5ce44182675affba31a26750d715d2a85ae572"
    sha256 cellar: :any_skip_relocation, monterey:       "a9a81d71a4f08b1a5631b447f9ce83e924b212dd6d626e28d9669917201e04e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff0a2ed05152ebb28b06c0f713784af63dbd8301fc60931570d664cd9b743ed1"
    sha256 cellar: :any_skip_relocation, catalina:       "b4a118aeffd8671f4e5046b476f6a890bfbb5013261aa954a35b5832262be8ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ac5512ab8132ac093ba6df7e42299c344876e1a70fe4570ab047c7d58278680"
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
