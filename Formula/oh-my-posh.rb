class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v11.3.2.tar.gz"
  sha256 "b8140489afb8b36034e5832fd3f057b320833bb708b67cfee523d039b4277ba4"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10ff40c0320629ce89d66d87c57bab4b7a28bbd9c9ef945963949d52599221f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e6eb5bcdbea2cf71431a0b105fe5b7d0e3762c49d16c5a7784a1fcf2f487654"
    sha256 cellar: :any_skip_relocation, monterey:       "34b9f5c3753bc6846fe8fd54ab09e6a8ed253647ec3dc137c09a64b41c8a95f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b0b4680b4a1dc8d1a1173785d69b06b758831c6fbf703ee74c134e8373208ee"
    sha256 cellar: :any_skip_relocation, catalina:       "6db43c84cdc27a6d610132604cbb87f1e61df469a85deeaaab8ed8c2ad1693da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "687159bbf3ee7e8ae4cff8cf2dd89c8098030a579e620863eff4b5d3b3870d7b"
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
