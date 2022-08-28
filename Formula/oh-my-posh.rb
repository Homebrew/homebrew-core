class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.36.1.tar.gz"
  sha256 "1030fa8f72477d3969262fa9f8b6937007614905c20d46124cff7500c46866b0"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ac6b320bb866e1609c9f3c39cab88c6b144d63b03eb03052766ece2b817d065"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ef05137ed86263061f24978aef01fd9b5f3609115847bb9d5251812b8968f6d"
    sha256 cellar: :any_skip_relocation, monterey:       "df77ba44f34d6926f8f7ab73d4daf742bbe1f7139a83acf81be287388e770d93"
    sha256 cellar: :any_skip_relocation, big_sur:        "be68100800d4f80f73bca697c3237caa68c8341d62d3c4a79ec8fa074696ddd6"
    sha256 cellar: :any_skip_relocation, catalina:       "882ae6023349be2d59f84b3e46d8fcd75e30fac745ecc8726b5977b15a6ad9b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d3d8edfcbcf658140673a629dfef59e2da6c6ef67127d171efefc1197077070"
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
