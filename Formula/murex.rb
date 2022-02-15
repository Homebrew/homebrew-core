class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.5.2020.tar.gz"
  sha256 "d4cc4dd698b5b54972780dfd4d4e22c5fdccccc917ba58e8e202eb6e7ac926af"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f43cf6f58142233a37e87307f5944fdcd5b5ba199e334642a78b24e523f9f47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3a7ea2a59e22ced924dd0f977aab490ffd1307f24d69adcc6706ee838e075f0"
    sha256 cellar: :any_skip_relocation, monterey:       "802bb6ffc0fca8982a915091af3c9930b446654dfa0144d2220cbe10eb84ae4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c4850659bf1ad63ed63857ecb2c17720d5bb08aa7ddb41348c841f5160d1436"
    sha256 cellar: :any_skip_relocation, catalina:       "650736fc7de66db527b475d343c22ddf4bdd429c073bbd390ade299bb4b4426c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8687142b5113629612b2b524f492ce5d4f7d00ea363d551eb78a42efd5d91af2"
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
