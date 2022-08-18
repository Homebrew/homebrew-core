class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.32.1.tar.gz"
  sha256 "20e6965bba207bdfba991d48927be69695f95770130a7fd53fae59be766a2c54"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff605457e45da5e648b79905a9de4c35d95d8e388887e2056901e1a3e4a01c24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "650cbba3d7515932fb26473545ef0e5f12b821865a6a0ecd82bd29223785ced2"
    sha256 cellar: :any_skip_relocation, monterey:       "d496a588eef52030de4c68e2961e21b323ad695ec1f139935ad1f0079cceff6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "94901054a92823c0a0adee4d2d06b5a26edef73517a3aca0022b1a2e47621ea1"
    sha256 cellar: :any_skip_relocation, catalina:       "c4f53087ce23bc9cef7a13222cb2cf340514b870fbaf12de1b3276aa62375cbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a2c0b8f3773541c03fb9d330d70b465aa3c1b5e11a112e73d0fb022bea531f8"
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
