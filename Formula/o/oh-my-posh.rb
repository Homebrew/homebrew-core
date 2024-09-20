class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v23.14.1.tar.gz"
  sha256 "281971ea48f2944fc22786a39c8ea71e1f406828ebb689e879892d293b7d3d78"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dcc01cc8a9fad5dec2169a0a0a1bb48904f24641af7198d17e6f7b6abb95efe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e71078179f6c3c1a098e34cf65758395a2311dca57b219347a874e189fb13b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4749157f302ef6e785b5b7154bd9532b8b418597eb26f01cd36f79b906618696"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2b18633a862505eb99889900529a10f7127427069331cf9fbc8fe4d0d527763"
    sha256 cellar: :any_skip_relocation, ventura:       "04f0e8582ae8387fc4c2bcbffd44f6050d59d5c14efdbeae5a24625369b89886"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd8498fb219e60f3c1e301f64f13c0e4f87704aa1fa74ddcc0eb1df93100d075"
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
