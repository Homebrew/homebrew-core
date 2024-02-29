class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.11.7.tar.gz"
  sha256 "e7bb94d3c53e0d244897d89da202c8e197da7d59a2ddcfc23f49dd9e0db923f3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01a780c514196b4a9cf62f4786db6705ef627f0909c4a6fa9acbf5e019b2b3e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2774dab45b3d90e3690a47d936be54582824fd5e0b1d397cf549531595e8ff5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7979d4505a7f211e9cf924aa4d99d155d8f7ecb9e28d17d11e581c1f124a093"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb69dc51afa9f68d2e1d0cfffb59a60755fd2204c8b45631c5681c8631fc2898"
    sha256 cellar: :any_skip_relocation, ventura:        "1aad31f7d1683e4584691aa232b2387e1b96b9272c5a26202cd02d23a938b805"
    sha256 cellar: :any_skip_relocation, monterey:       "da1b7133ccf65e26ab6c422efb0659c68bc55863b049da9fe91e539139afe40e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a565a5dfa114b9bc9d79cbb2c0d2d7dd959e86859a78200ca4f38227d581d35"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
