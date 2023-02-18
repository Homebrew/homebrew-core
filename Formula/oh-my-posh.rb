class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.7.0.tar.gz"
  sha256 "33a2d07d509837df98418f6430628aff2a1743ce36ba768322f9832bdf3de639"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8551274851cb4c69b838687b753fc70816b44b32601935f2f61dceaff768b6ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a783bf92c8fb528552bb0a2b8cbe7a3af41159b299db6b6be5a247fa8119a788"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6145bbba642e9838c83f4a7279e8fd4fa8b581e10f73c148e5c5cba488fc6fb"
    sha256 cellar: :any_skip_relocation, ventura:        "73db4e5c47d5ba21d2adcb5063652dc4bba01326b116f57d411fdd1dce86cf2d"
    sha256 cellar: :any_skip_relocation, monterey:       "81800ad497cc91f07218f54ec4d3258e782b20ae1cbb66402b0b17065aa3b9e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc1a1a1fd9115e37f8987dcfb1b54ba1f0a34a814e8b4abb0eddbfcfa684602d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5237cddaf596939b8057a10168d7ef6e27e808d4bc24cd3222eea44ba0800986"
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
