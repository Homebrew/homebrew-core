class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.18.0.tar.gz"
  sha256 "68a1b33353f4da18a5c7ad40d307255a8bbba76d9665ed05fecffc4d1e6864e8"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac744d6492cbf86ec24bb1864a46f5afe981a32a113532dcc7945c2f4b7aacb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f56a004d42b4365b1c3c6f93fe9cde0978528b9db802230d2ec528794608c92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "921fe4984ba9a00eff3acee15cb7fea27fb2c2bfe3022d69bbcdbf2479b0913d"
    sha256 cellar: :any_skip_relocation, ventura:        "3c7138a98a1d98958ff6f8a01278e297655d7eae71d04551b928f16801b6dc59"
    sha256 cellar: :any_skip_relocation, monterey:       "833099987527ffe584cd7096bdbe57af62526004833b6e36b786a95586a8b968"
    sha256 cellar: :any_skip_relocation, big_sur:        "202e3f26d9316eaf87d8cda6969425396b796c4f82883eaceaa8bed0122d499f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "888be7cfd1cde5850ab9102b44afd65bcce1c5f4bf9a55fe8a05b6be332f7561"
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
