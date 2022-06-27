class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.7.0.tar.gz"
  sha256 "80e6d4937a7bedb8b6819cccca5aaa1309e52c75faa629c7b8547785f5f41736"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e169430b1ee0526f797b5dc565f93f944e58ea849a68626479aa9a404ee7a7e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8abc51d97d2fd55897f25173320d51f81d70a4bbde287ebfb138634a6f94b330"
    sha256 cellar: :any_skip_relocation, monterey:       "feebc874eaf6426eb8c391a68bd29341f17615e0d17f0c7a99d8429bf904d7e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "57c1afe5acc8f604f2a5ae6216db7806abd2465707a3de6c734a724eda695877"
    sha256 cellar: :any_skip_relocation, catalina:       "8e36339e8eb35f8f6e7e947409f47e78472f070b203518350bbd1b066ac2ad5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2c4dcfc4ea6d22cc489fe58e584bc1ab393ecaac284cb11b7bfcf276fb83786"
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
