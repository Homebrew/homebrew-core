class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.21.0.tar.gz"
  sha256 "7f1f5d4633ff6a4d6b6a8ab46abc6f34821b6e9f8e87e0aa3e69f3536d13adaf"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9408ad85201043a2e2aa2f3f68ae622b4e3bcce64002e5f69684ffbe906f48a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d465c78fe1d645e0530071a1d47d01dbd71198725741b8fe919ee6ddc2473971"
    sha256 cellar: :any_skip_relocation, monterey:       "02bc097b4c8448f5f010d0688f4c57329c9d706d7a17302518121f22dd559924"
    sha256 cellar: :any_skip_relocation, big_sur:        "00eba1f5209262c81cd56f2aeed456524c25bd73aae390bf9207190f38e06806"
    sha256 cellar: :any_skip_relocation, catalina:       "95ac4632357b4eab6e9aad3c5543f48ab28bd9433878dc821c491a0b7de04a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37a513dbf231e3f87f41c6dc3d90dc1977aec309ed7293c90501746fef9394de"
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
