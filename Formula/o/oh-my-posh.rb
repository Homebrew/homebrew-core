class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v31.3.0.tar.gz"
  sha256 "d5e9c7fc551cd7da96f4cdb0e067e58ca582e354bf9ff18755478456bac6540f"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "656dbcc4512f7263c7889c066edbb1932d9f60d604f96a11f1e81028cf0343b0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "21b1f913480b5fed82c6d91afd4824313374f4788d75a1695507376274f7ba41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "53b464b0d8bcd3151b21e5b18b21ec411603da005813f01d3a21daebb01c0aa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aa38d79ee02271495ce2cc90e32abe47478aba4f726a4d89c67b90aa319941e4"
    sha256 cellar: :any,                 x86_64_linux:      "50bbe4b22ace69010c833dbb2c7765effa1a6db93c1549e3a8920ea76cd420f0"
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
