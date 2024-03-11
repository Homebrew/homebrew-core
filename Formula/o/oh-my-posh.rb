class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.15.0.tar.gz"
  sha256 "72b296fae2e42a368acabf06a6e5b040155e05b2a0f195e5701599dc9a5c9389"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5a508867d69fe22e13cef6238760a0ec9750436a1f04114f0613af0d28c1c30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09b45e78780e53618a5f5b328caf5bdf0793d5d1d15639b7ac4ac8a19d5cf73c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fce19d313bca268f25a3ab2c0a68de3cfa584299f84499ea70fce58ab8a08c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fad9f751668fcfd720ac3b7bdd7a62aa53d61e1d51c3e6f80e88f4fb3b5b97d"
    sha256 cellar: :any_skip_relocation, ventura:        "884beaba203973ccdf800066aa46afa958fd1c875250df2b8837f159d91fb55c"
    sha256 cellar: :any_skip_relocation, monterey:       "041b966f92568130b83849e6fd3d3cb3d332a3222ee8b4b0c8066f573ff86db8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a628bce1bec33d495f4a33f3d57e14f0962fdc1c186f5cbe5ca52b8960046069"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
