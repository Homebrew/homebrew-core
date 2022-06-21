class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.5.3.tar.gz"
  sha256 "775e76df44107e54ff7a77d0522b49702f70a3ffbb47c0eb8b16d27a7b4ca269"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60a9ec7507914c0f5c7b6ad35df547c184a51b99a5f8ecf21cd0e437ac0ca543"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3507b7237d4c5ed00aba1d098600591acce4b6517fe8274686ce1c54488b3868"
    sha256 cellar: :any_skip_relocation, monterey:       "b948279480fc57af0749a59df11dc0c430835ae07a48c4b61a992bcc48c91a36"
    sha256 cellar: :any_skip_relocation, big_sur:        "f14a0906c55475c7e06ed5f2aee1a1b4ec1922d616e228feb8b9fc4783960857"
    sha256 cellar: :any_skip_relocation, catalina:       "8ce2043a680dd53b35fed40902531bc9cf9ecb834228ef7e22d06e287adb2f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dd25dff7fa06135fc98342eef2edd6f4f0e36c706310950069d5ab7edf8dcfa"
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
