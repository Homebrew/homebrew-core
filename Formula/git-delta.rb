class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.13.0.tar.gz"
  sha256 "5a0ba70a094a7884beb6f1efd4d155861e4b3e3584c452cabbce1607f8eb0f30"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b871380c531484f3eb60c3f3965971d4e1974846e23ebbda2c4c4b4e6969c279"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a37fd9b4838aa5f039aa9b92b70ed92ea7e2e3cde223c848f64b7fc4520378a"
    sha256 cellar: :any_skip_relocation, monterey:       "4fa85062a8ec07516f772aefea1d0da0c70500b4992e86157e4daeac699db73b"
    sha256 cellar: :any_skip_relocation, big_sur:        "009656e3089eb400dbb964db081e169b172a9d3918cc3afdc5ca3715c0363c23"
    sha256 cellar: :any_skip_relocation, catalina:       "eb71a5e4badf7f096607feb7a58dd5116d2954705948a43045a7f943c3d27999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "725478975f1e92f80fd7e5584cf924e585e69f9c2e4a39e64ccf83b3e07fac2e"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etc/completion/completion.bash" => "delta"
    zsh_completion.install "etc/completion/completion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
