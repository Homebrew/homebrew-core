class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.12.0.tar.gz"
  sha256 "2133ed2a3fa4e08771635ec3baa58ba6eeae1f6e518994538098e91d74a510c5"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e2a809e83386a40c08b0bb9712c80eb76282f840e5493ed9d147481f8665b76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6d3cfac9ba6354476ed887b26a90109c47c072acef8601252f227211c0c5176"
    sha256 cellar: :any_skip_relocation, monterey:       "a9200ab26485e6af1098e01e0119f61d95fd433e9b39f31271bd04962c3dba8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1ba7993d57e2b2fd8cd1af8da3ca1668d79fa2236963ea1038f2c4cf3df7c95"
    sha256 cellar: :any_skip_relocation, catalina:       "a7ffe92e0908b1d5763f07792578964bf4430a48c66634319bc48d06bb8ea082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e31f0122c465f141956fa7e1eb57300d05c02fae74801e813c9a6aff641ad812"
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
