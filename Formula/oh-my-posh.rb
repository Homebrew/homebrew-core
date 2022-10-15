class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.3.0.tar.gz"
  sha256 "d01cdf40bb451b0d9d11d4b9101a16ea711702d8b78ad09a1ea1bfc4ab732177"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "199e2e153f83e7c42f7ee06648fdac8c10f557f42c140c1a6739d07ac02548ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "919d99d206c60b5f0f15dcd4c07c6e2eddfb8b9f099d09f74428095b94e1e086"
    sha256 cellar: :any_skip_relocation, monterey:       "91fe53963cd74964d7924689bec75af22080deff9666ecbbe3e24df889ba6241"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bbe6d8ed78b1bc65812c31c93768eb088f35b1fffa8b5fe6ddf79522d6bc51e"
    sha256 cellar: :any_skip_relocation, catalina:       "9286b098d0d99e3ef553f74ab5c65ab497af1b3e64ad44f2a92d2b5265ca0ef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2fd2ec4a5c83e28acdcf49d881b95b9c2b2202bbc02654550e8e07fdd987aca"
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
