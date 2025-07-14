class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/refs/tags/r35.tar.gz"
  sha256 "bf2ecd63eb75ceeb88f42977d49515bbd755b7f3d4db651a097c6ba47fd2d989"
  license "MIT"
  head "https://github.com/gokcehan/lf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb2fd1277994cd58d26058b7b79b560563b1733f86ef7b1931afb091ea5f8929"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb2fd1277994cd58d26058b7b79b560563b1733f86ef7b1931afb091ea5f8929"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb2fd1277994cd58d26058b7b79b560563b1733f86ef7b1931afb091ea5f8929"
    sha256 cellar: :any_skip_relocation, sonoma:        "72d2ccadb950ce041d90cd51412d923023acb6be4f95a7e71b479dfc99a5e83c"
    sha256 cellar: :any_skip_relocation, ventura:       "72d2ccadb950ce041d90cd51412d923023acb6be4f95a7e71b479dfc99a5e83c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f19fd571e8a2c1ea5277641ed7d335078643cc7a6e7cfa40ba6a1021778f86c1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.gVersion=#{version}")

    man1.install "lf.1"
    bash_completion.install "etc/lf.bash" => "lf"
    fish_completion.install "etc/lf.fish"
    zsh_completion.install "etc/lf.zsh" => "_lf"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
