class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.6.7.tar.gz"
  sha256 "69de8d9f47b67ae7994f852ce93a3d76edd9242537868709f8ebc0593fdbb1b7"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05032aa532a348636ef9fd84e4aa16047071607c30c6cacfb7aa66d8eb37b9ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4db0b401d133edd323c6720bc4d1c23f23e23829d70acf02edfa3302f12d1da5"
    sha256 cellar: :any_skip_relocation, monterey:       "233df119b2746fbfa56e0d321c13bdf2c8b297536c6ebe34e96a5d5e1e074bc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbd69c6293cc32c89eea7ce5755295d10277285a96258b9ea9152f2017f99cd1"
    sha256 cellar: :any_skip_relocation, catalina:       "aebbcdb4b5f9fe5cc8f0e6132dacaf670e3398ab0e8b3002593afe365686af7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4fd6d63c11d6577a94abcb9b8e36b04050adebfa33f930e73867bf9a41450d5"
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
