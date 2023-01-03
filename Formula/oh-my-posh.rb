class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.34.5.tar.gz"
  sha256 "54dbfe94be655362a310c3907e37192104154c4a7a5aa2d1aa068dfc7c0b120c"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fb621d4f22d951c38632aa68b5da9694d924a9b5a101427c66d7d6fba84e144"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fcc79b1b184cb55a7426e91f7c3393088fdd9db5e661240750f15b1bfcc4854"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c31cf31f22b21adcf549ee67f8d601af616c4eaf2a9de73d1a5d45e7d601bf8b"
    sha256 cellar: :any_skip_relocation, ventura:        "baf346e6130de47cc54a8f24509f324513fa250d8e5ce2dd42c6c00e2b9684f9"
    sha256 cellar: :any_skip_relocation, monterey:       "15e30f35e815316c1e5eaf59ef9d5b61952b30fbdfea5f870eaadc2236bb0d47"
    sha256 cellar: :any_skip_relocation, big_sur:        "8406eb9fcf325c99196c11bcc5cf23b0089615a284c3879fa00c9d1f371fb546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e4247e80116ae57551d0b40c5f98332279e80f7cad899475b3bd3c8f3afa34e"
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
