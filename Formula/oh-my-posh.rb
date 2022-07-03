class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.11.1.tar.gz"
  sha256 "a11ca4a17d10147c36b2188a355734d132589f49909c7ba0fed3de42aae24cd9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbba5858b38266212154f76d8d286b58230920b76f410c3eed79bc0093fd408a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "198fcc525c7a32b36133fca41fb64f781127069b7c1df9fa80d2bf1ffb6b0850"
    sha256 cellar: :any_skip_relocation, monterey:       "db8410ab15422666cfcd85ac37e2493d25920a0a288a5d92f837a11a85f4ab6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa44c53847e9b51c7fbf25e27e4787eb019d6bb5049fb785f37509af3ecf8e57"
    sha256 cellar: :any_skip_relocation, catalina:       "5b92829a3ad7652d18b9991c48f47ddca2f104b0b2e1b5fdb28f95b4806fa14a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05fdef0f8e47e48941c559ba110fbd82bd80ef17ebc06c60dcf8feaa0a7d6e26"
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
