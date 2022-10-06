class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.0.0.tar.gz"
  sha256 "d207cc8937e8bd0c567f01f2e7f4c4ca7acef66a608f4657ed38df2a8bba8185"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f766ce454a92dc0bac453c1d1a234ff07fe5e5ed10035c489575e7ba6744500d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef63a8c7231a85283cbb833036f7d066ec33c1616c74117b231a5c6dd81a1c1e"
    sha256 cellar: :any_skip_relocation, monterey:       "861aff70643a474c56431b16379b5f5385570ac865b95a26f0708f2b6910c5f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c2f7adc0146694c9634afb23fca8b972a29b5915c2ecad27f67204f7352200d"
    sha256 cellar: :any_skip_relocation, catalina:       "5f77a37727f051719d6a71f6aecbf7cf942205acfd0d5e746da52847995c2d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69b56ef8db4c52188520c3cd4235047a08fb39b3fb0e2feb2718b38fed15d0fd"
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
