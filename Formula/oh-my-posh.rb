class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.75.0.tar.gz"
  sha256 "ac715c5d8b5a81480dd4923d5253ef289c0004635cfc6957f32f28954700cb9f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca3f276983a6926f8a80216b808071e4fa6a7bfa55b77064b4c07334679b64df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6ab1aef5df8c59b11cab1e6853a2e1f15f0348f3e950b4bb8b0638e840f0a37"
    sha256 cellar: :any_skip_relocation, monterey:       "05947fa50587e821aec46728e69fb075334012ae7bc6914362a4117bdffada2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "124de040ad1c9183aa908f5e58c1bcb35b92c4170483f1f39f41e9daa2862816"
    sha256 cellar: :any_skip_relocation, catalina:       "01ff802ca7bc022851f311b16412630bb0f38219afc87f4b2d1327860246aed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf3808f64b16dd28355d9a4afd5e9bce819a2a65037ae0e3e6a03942d4ba0dbf"
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
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
