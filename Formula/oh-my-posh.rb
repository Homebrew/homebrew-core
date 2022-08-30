class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.36.5.tar.gz"
  sha256 "a0ee20d21851b1fcf8ce9ac0c6b7ea0c210d7090cb2865e11c56b3f10e886e23"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1aa5a9c5d19ca1057d7cca0f5af06c3c146b84d96eba41ad1999e37dbab4086"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f23f8ed9e925e368ad89dc8e0c024b9b7e9540503d355e07119fc1aef0423965"
    sha256 cellar: :any_skip_relocation, monterey:       "f5a2cd00e355b70796fe19a1ccb5bed2ddcec375c8c54eeb9e7d71add489c3c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b85355e0bb2a0735c27fc4bbf80bf593f15e43f9a8d4cf1cbac8d7004bc2317"
    sha256 cellar: :any_skip_relocation, catalina:       "5cb1cd1f19339995d76a20951d79964cdb2ec3ae03641cfc6423d01c39979172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87c87da105654d8cc46b34e64beca7b8c8a90456e982e9e1990b7e74301c2d57"
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

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
