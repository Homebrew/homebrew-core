class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v33.3.0.tar.gz"
  sha256 "75b86a279eb5d191177eef57b20a2cc0a1bc5d41485928528e4b4e28b6e9d558"
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
    manifest_sha256 "80816d34084975c52f96c82ed19c0ce0060c1becd2ef6c12d51a1672227fb55e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d06871b007ee99ce73e24ddbc800ff085ba72aee53f7d3c32ac928b1deab83e2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26ce8e934d7f98807802e65c50338c497b7806d0d3d9b39be019b730fe0a358a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff823e80ce3012bdd50cb2cc1a4a80c4bbc0ec84b3f693ec41eac19e21b489f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1d490132957e3ecc098045d2c2bf83f96b8d1bc6d40c49109364c456bc17204c"
    sha256 cellar: :any,                 x86_64_linux:      "4a635e5369c424b8f567febdbbb64e6afffcfbe42c6250df6ac5abd60b71a80d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "src"
  end

  def install
    ldflags = %W[
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
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
