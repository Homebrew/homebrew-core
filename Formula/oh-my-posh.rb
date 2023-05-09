class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v16.1.0.tar.gz"
  sha256 "1548f838b73cdd7aab48f31965f07f4fbe973905ac8b62db74f5f2d400b27750"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cbb4a6e0e419d604035621d3e8820603335518eac635734bf7cae5d938b8cbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31a4501912147c63afb5af20a2ec2a13122edc66f7f3ea0d3deb5b46300dfa46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47abf4d261cac6be797da810155a3fef2aedb9735de3df1d10595a1b8d3120b8"
    sha256 cellar: :any_skip_relocation, ventura:        "33929351766c9cbdda644af12375a909cec72ea30a8fcee6b02091a944826ca9"
    sha256 cellar: :any_skip_relocation, monterey:       "8f174cb454b5837ba0e5276df7852e7a726f0247ee3372dac52d78ae86a21ade"
    sha256 cellar: :any_skip_relocation, big_sur:        "dea4a5b78bd5e15dcb186061bdd8485430267427c3e2918f7f15d3b4792ecf72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aeabf5137ab84c9efd2c917bf8277ed85b2733f70d39ccbf52d3cc12355277e"
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
