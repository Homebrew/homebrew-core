class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.5.2.tar.gz"
  sha256 "3d47b73927f60c8072e8b4b4bbf14596556dca24b6338ca777ddc6720b848579"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a962fa00df230ee6366a7b9f14e6c54e2bbc190841c0271fab11cc4754c0f8d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95ca2624e9ca8d18e3b5d6ef3d23019e1b412ec45597611fdc8f21eabbfb4e70"
    sha256 cellar: :any_skip_relocation, monterey:       "4ed8e4ebf4fe9de20432f1ed7645bc0c37a9cddcbf212b79c17d13bcfaf7abdb"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e8d090d7bc66711c5d48ed3649dd87bae13bd3709e4472d77b24ea34b01d403"
    sha256 cellar: :any_skip_relocation, catalina:       "25ab2d00bb9fc6cad4372b89fd98fb7ea0bc402228b2f5da82fd1e322417cc1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba24af0b28682584409413b9824ea620dfa1a7763120170d16f2373f8c576331"
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
