class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.2.7.tar.gz"
  sha256 "061ff0e25d46b9dcdd4aa17498ab11bb2d64468d12a56cb1dfdfd87f5900b008"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90ab87d5de7ffc9e4c83ec9749d70192453488a2441196a3ac51d74dfb8eeee5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dafa9bd77bf41e27fbf6d755754813a14c1c6d05fa09f2b865adcbdc03f9c044"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfd8bb10aa0eb05b142bc27c3479d6eda0bbde3f8d8ebbe48cd0ba9a30183128"
    sha256 cellar: :any_skip_relocation, ventura:        "360a3fcc64e4f68c6d94d5b2559ea1d84fedd88805fe2f00a19e4ae2d38c4a94"
    sha256 cellar: :any_skip_relocation, monterey:       "8209ecda545b98788684135b3a8ceec479274e0ef8a6caca8586713f5dcb704f"
    sha256 cellar: :any_skip_relocation, big_sur:        "06b59ed250ca604470d1d46606b628cbb0b455416629a0ddb8e6a45d8b3605b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc554860a04b452462a24bfdf3a444da0edcfc9d15aa1c8eb35065e84b561781"
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
