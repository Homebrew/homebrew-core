class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.17.0.tar.gz"
  sha256 "30908a48e184d6b525c77943a6f245b8344efe9c188952355f83555dced4a619"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "130f4bba5727b3c78bc4c94762975f00f9e0f166f306878d57d55f55a5b2e3bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edc0643cd81a400a243c2e1a0fed12bbef564e77ae81e4c485b08980552e609c"
    sha256 cellar: :any_skip_relocation, monterey:       "0c0ed7cc8911ade10855946a29292807161fa89391f79359a89a5ecea2c06030"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a5d12676d6792b8ea7849c9d52dc9ef85cc0abaa2a04b89fa4470650fc8f650"
    sha256 cellar: :any_skip_relocation, catalina:       "1f7b0d7557e5c026baffbf830db67398b8b85f092c3451eae8a5e514de67b8a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "126fb2367afc1938df5af7e313204eb00171db7e80eccefed89c316ebc7414ad"
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
