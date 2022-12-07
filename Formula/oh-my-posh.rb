class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.26.0.tar.gz"
  sha256 "7120cc31ae457da816e3b1b6b497a2829e1b71bb745cfeff2417ccb6f3edaa85"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bb3e9af969d33e0566a41058112668ea7e99c438d6735fe725da78d741c0812"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63b19819b8b6e1291ac1374284a0a780d2d7f1074b2f7c47011823ef851f794d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b370014800426b00f1ddbe7785360e708f95067826c934d3cb4195474ed165fb"
    sha256 cellar: :any_skip_relocation, ventura:        "315b5a935aaf25b07fa16522984ee94257de1066637b99e2eb1ad3f2be6eb689"
    sha256 cellar: :any_skip_relocation, monterey:       "3a35178ce39df19581abfcc5583c1fd5febff55eff84c74fe0d58484486f7a78"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa91b78319bcecba85a7be9281a1138253661e51a14fd4739e243d86765ff848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "303b30e431b0ceda5e8dfbfc0017a8312312b3b5a17bcb813c216ea95693f09f"
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
