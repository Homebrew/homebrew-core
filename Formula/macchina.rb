class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v6.1.4.tar.gz"
  sha256 "ec6f55b373d5d4040f222eb589dbb63c626cdcdbade69a77d710c2318f424b3e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca0d6c90e70e10b9c60f75d0b704184706c2bf59cb2988e6555915ab87457655"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e456fac968bc79fb29ddb5699086e41f109e2c5e6ccb6674ded052bc1c6ddf86"
    sha256 cellar: :any_skip_relocation, monterey:       "25e22c17eebe3ff5c61da0176521f51c99b2b7d80cb0ad306025805fd3d933ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4779e844f9b5295abf2c68c47a0236339f2b3c273809f0fa65391bab2b6fc91"
    sha256 cellar: :any_skip_relocation, catalina:       "58b2fdcc934453740f51d901eb418c522fc104c0eff085fd32fdfa06ea253bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4be14d60bfced8ced9925a18664c4d8e5dbe69c856c1bf3d2a5ac40e6c0eb9c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
