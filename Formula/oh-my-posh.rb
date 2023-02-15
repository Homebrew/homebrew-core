class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.2.8.tar.gz"
  sha256 "92d34038f486395a973254070b7b42a63a176851b7afc8500be1cd2a22b3440e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d97de7f803da0eeabf5eb294467b8ad6b9c72e61ba974cf59388c8ef3e5a2d8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fa354555c01818fd65d1768505b9e34b393b6762d6068e880eaa665cf9c0ab3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32f7261f9e3937945c3c39491daf0302848533488970ce6078f408093658ce91"
    sha256 cellar: :any_skip_relocation, ventura:        "727a94fe833928368dc774379c05dee17a32e591404b74da8f89116f07de58fb"
    sha256 cellar: :any_skip_relocation, monterey:       "e53137f814cfe0fd5f8ab7abad4d4eff5efa85dafcdd664c945781e0f9a7dcc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "88be092a20d1e420e1a57663f52f8e034c62bb4385ffaaabecfe6661619b73bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7991af5e092443fe2cb4eac86f3db8589073fff40c9d96628e281a493383170b"
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
