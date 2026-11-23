class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v33.3.1.tar.gz"
  sha256 "790cb6863820f9fd11bab70d3816d630a30bd0828ece118ca6a1cbc0356754e3"
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
    manifest_sha256 "257623d0c9254f3e6de0750ab83c9e579bd346273a3516081a7aa2df2413462f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0e975d9ea42331411af5302db6461168882ebeda4bcf5e664dee396e545aa6cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "589bd922d3e1836e838610cb9ff122ef2174179be0a99457822675e4ea9887b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1475a8cb2c9eab8699844f9eafbbf9418e8392bcc616ee6eac16e0b87f152287"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7446b01c3bf1c0283c4e4fb280519a9f3b26cd99b0d832853087915a7bb293d3"
    sha256 cellar: :any,                 x86_64_linux:      "7d58a552c23b8a94a4e0aa6c56efd30b497353b35fd76f2a6c925037ba203db2"
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
