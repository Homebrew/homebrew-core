class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.8.0.tar.gz"
  sha256 "a38ffca22683d41fba781d44d92a764e2031341e27c22e175ec2d9ecc2e16128"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff24bbb29bb3b80e148cba36cedbac2f77bc71b53544af414428dcffebecaeb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe8face8fd3835c3de2af6a05d897fa290e1443b8b22b4d8432fb5d7c48b62e8"
    sha256 cellar: :any_skip_relocation, monterey:       "3e5aa877409723aab25016648dc022f7792d66748b73c7efe2b8f4f2ed16b6dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc0017955de7953bed8c63f09ba20a75bd35ebd7fce4d1e091ba7205659961e8"
    sha256 cellar: :any_skip_relocation, catalina:       "d22dddf381a2b7982d983e8dbef6957367f4b64d983df453946b6bf8001613ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bd706e43ab74f689df095ef7b1ac0efdb4da3a023cfea76ed77da1d37cbfeee"
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
