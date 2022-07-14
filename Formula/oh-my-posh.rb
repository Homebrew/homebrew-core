class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.17.1.tar.gz"
  sha256 "c1b5fb39deaa0d5d0f2c2fe4e6057a632241679fdf794b6f2bc0228446dfec46"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a7fe0b0a476df38a081334ca7c9361c38c3302ee8253f853daa7f4c30350e76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8002aeb805a01fa4348fb8c5df4e83b4d2b9d3c370f515a3f69d4b6d8841a62"
    sha256 cellar: :any_skip_relocation, monterey:       "36ee85fdce21bc4d6493be145fa55dc2e8ac77cb422e69ce0758aea7c3417702"
    sha256 cellar: :any_skip_relocation, big_sur:        "e81f11602ab35f77bd61c4bf67103ab99df6d0e0ce531045f9d11e1250649ff8"
    sha256 cellar: :any_skip_relocation, catalina:       "1566881c8561fac70f528c389a51c124e6b884cfb4cdd42426f0f84f3e6e4d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c2db0bba416cffb2ce4535c4366c5c75d8946d653b8444aa305260ff96ae076"
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
