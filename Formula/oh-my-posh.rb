class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.6.0.tar.gz"
  sha256 "bfff84b9a3f0d19aafbf02c0e1dc62c7f26b8491f6d5ba6bbda0ce599dcfa463"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88aa4869dc8afb4eca2491b292b43faf70dae01658a27e3210f32dbb87fcdf63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c92c497451d37fb5ad441927d2cce16123f1d3ec8cf3df3e4cc18e0eace4278"
    sha256 cellar: :any_skip_relocation, monterey:       "c46107489646628406603af0ee028afd97fe8116ac1330ce5d4430218b026e5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "068a5591213f5032f28d52d86f308078a0368a9f6526b2ba4052d2e076317dbc"
    sha256 cellar: :any_skip_relocation, catalina:       "cb18c99cabba2d95b8a8081e9020ff0f65d70e15f13b510381972f438243f9c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1588ae52e28f4856bfa227f87e020cd5c3694180c643de3ecff0edda69eac91"
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
