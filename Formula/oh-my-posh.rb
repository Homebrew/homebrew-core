class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.57.0.tar.gz"
  sha256 "19dabdd3c523f289d9f6a25e41e8d89411ebf000bc09d71e02b7314733137293"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dd2b8765e546442f91c5da1c9b4b4472de13b07868218ca9d1160836a81fbfc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bca9bcb2dd48cd6694492415b74f498015c4896fc9921fcfdf96fc98a5e06dd8"
    sha256 cellar: :any_skip_relocation, monterey:       "0acd9f0325cd51b383952759c0061004b093b815d98a83a4aff2900daef2b009"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d06cc3092fc7ae288524de6e36b00c5d59f64c574f56a92a65d5d8e01d654cf"
    sha256 cellar: :any_skip_relocation, catalina:       "a981ec10bcf2bc2d658f252059c5b12c4d8639fcd7905bd6d00715df28c8d371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "828cc57ff1454e9de5ab8f29e4a6cfa03a2e1878947d6cf8db28f287f85a7745"
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
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
