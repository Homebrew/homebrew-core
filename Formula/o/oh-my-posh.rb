class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.11.0.tar.gz"
  sha256 "16b6569ef0986f5d753ca0b7476277e807b1259f65aaa704458840fb34f9eb3d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae19d906ce49c6c9bb04c1eb52c148ebce9c630cdfcfd6abc9bf4ed1a0632471"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "257d5736f6a9a9acf7dff62764ffcbe7fed6203a120f7dc4d660f7aff018527d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17c58a5ac4b9485760051b21e48b72150ee6af0515f6391eb309714a635e0e07"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d5ae61a3fec2a68de87875fe72a36a9b4c28c690d9551d5678165b40fb360ea"
    sha256 cellar: :any_skip_relocation, ventura:        "7dbb0869ccec2bfacb4d99e4b14c860f44bcd086b5440d261ae1821d940f8a79"
    sha256 cellar: :any_skip_relocation, monterey:       "a968236858bcfa8fbc9fa563bd3723de01edd5bd8d5898200dcec3ecd7dae7a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cda55fe96ae0fb76d5432d13b0c64ee03bb3103a223de3721649c336c0f39564"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
