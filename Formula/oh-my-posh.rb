class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.2.2.tar.gz"
  sha256 "ffb2ce112cf6514e0f6e999cff70a8aa795b4cd52e19d9cd044eee1ca15422c8"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6e1a60e3674588a648a10a5873afb83583e53d4f28b75247e2103a4da38f3da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb1d00620f6484f4095e64972947846a550198dd3241e3432c6f97e99d72a735"
    sha256 cellar: :any_skip_relocation, monterey:       "c8575c3217772d33e3ac0c0bc89b9bfd9d508114b5433c92e228b215a2cbc2bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d8500dc154ac710c33266413565e4968b010f69eaccd682e9a3bd2a866df495"
    sha256 cellar: :any_skip_relocation, catalina:       "febdc23f369fa99677b88990ceda8c72997ee01387b9ba6ebf74c046072df96a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fc101c2cf58c15ee489d7b5223fad1f146c23b28685c8ca393e0c2454cf6852"
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
