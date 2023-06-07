class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/refs/tags/v4.1.7300.tar.gz"
  sha256 "a04e01a2b0d7c70e8dd5e671dccd5009646d0a4276556fca790add3d7d7853ec"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fd608514cbc98a1aa5063bd8ddd564d4fbefa07501ce99fa596e64f3dd1d705"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfae2111ae24415043a997e9d3a07a6291360a90e92534738537eeea552f61df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d89d6ca10d049b2a73c0ecaccf81440dc84f98056034bc16f341706464f27197"
    sha256 cellar: :any_skip_relocation, ventura:        "53260bad51c7ae274783d08d2a8c70e1a8ee2f32af354b5114fb48e3d59fd401"
    sha256 cellar: :any_skip_relocation, monterey:       "0b5e7650eabf03c78b18c43106fa6a334f8ec8c87fa13e4788530a1ab22c5e2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2996846feb21316a7c8ad59dea745bd488906748d65d0949862a81850db789bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "424d78bf3ca6dbc80d5d25e2cd98b2098d611f7631690c607f95cf250b31e75d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end
