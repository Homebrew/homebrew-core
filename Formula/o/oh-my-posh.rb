class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v25.2.1.tar.gz"
  sha256 "f5bfec0c3a7991a9ebea0e2f04b07c03b05f8c2edd3d7dc1ac0df3ca88fb1883"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aec40f6ae9e76826f04c8c8ce69c4674480907ed48b5a354e181d942ae6ca021"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2a7a6642b10f471c17ed1ec59059e580ed03317278974caf86a7ffe16e487e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a75d313c7a1efa67a6bacb1dd56d261d8c7afacf00179b240dc1e7e2df536c5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c1222a3e126bc01263366fb166683e83b84cc3883cb4e48e13293df77c5869c"
    sha256 cellar: :any_skip_relocation, ventura:       "d7ff8ac7e0ce57aeba4012d50418ff988cb0bb0dd6ffecc57e30a5dec1efeca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7608cc2a5ab18c4a66483f5feaeecfe7d971ad3788ff5d6c6714c84c92a2f02"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
