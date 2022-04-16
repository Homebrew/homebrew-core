class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.63.0.tar.gz"
  sha256 "bcd23e49f21863ff35f18ecb63f2372346ba3cb2315986211af44c88c9e0c5dd"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0d10f48e82c53331f84e82845e9f377f9c7c4def32b7efe7aaa33ae7d7de329"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e825e30586cfcf075c6b876199428372f26c1994acb632a18c03f9e726444ab7"
    sha256 cellar: :any_skip_relocation, monterey:       "ecde43a0ae63456dc475f585a609d4beece5789093ec620e9b3f5ba02582e9ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9bf56e25d642abe5f9cc7d376559b06a6d27badce2c27760fc7be89dbd14c15"
    sha256 cellar: :any_skip_relocation, catalina:       "f68b48008a884f624ac5f4c233242b54595f91c979d1b634c7e27ddb977c3e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7df9d833d9224c2a92c0d5697b22bf01f78677924f837309837597d5a008d210"
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
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
