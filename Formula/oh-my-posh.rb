class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.8.1.tar.gz"
  sha256 "6a8433dc571821f0707e0b84015cec08f61c628e196b6fc9ce803d08aa85dddf"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bc8dc5b84f5c887ef1b599a299055ce4a641382c82e5da65617d6b82d3485f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d559313423bdd18b362280229e925cae8f366f5336413d2a325983835a863bdc"
    sha256 cellar: :any_skip_relocation, monterey:       "52e5c17e7c929ad6a25636030c82473ca969041175b89a0d315de66a4598468b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3e5ae98eeaaec2a3f2c1f4b2b1d2cca96a5d4884b5d6d51066e4c88d0e6b6bf"
    sha256 cellar: :any_skip_relocation, catalina:       "e493f3dc745756c1abcc9aaae599a3ac53abd8986718bd8cfb073372ba5b8c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0ae4f152781607bd6ffbd14d55b9cb3ebc6acd56bc2540a8281392220aad0bc"
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
