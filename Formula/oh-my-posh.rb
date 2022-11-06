class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.13.0.tar.gz"
  sha256 "978431e4693fb2acd00a841dfdb294f85eff9951299c7bafc76f1116575e1ad2"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8583c5ab41fd176a7f5eab206a2c661134410b3a7e85010d0ebc08126887429"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c69e67d09d093069bd7289ac7acb2ad5dfed587f916807130c023296f51d8be"
    sha256 cellar: :any_skip_relocation, monterey:       "5281dd0eb2bacbe460b486a59861092f40544e10c631a989b2a3ece72dfc2b33"
    sha256 cellar: :any_skip_relocation, big_sur:        "e193d3a56464eb63af9897291018c44e276dc645b904293e5cc4dcd73c7b34c2"
    sha256 cellar: :any_skip_relocation, catalina:       "89acb62265771d64ac1ef91aec4dc10d42dd789dc29b3e2bde270a9c9720267f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fabbdb11d1f25dd8251e0ce36573cf217800bc78b5c118ca00cb56708b57b390"
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
