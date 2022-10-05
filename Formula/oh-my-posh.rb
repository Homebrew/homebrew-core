class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v11.4.0.tar.gz"
  sha256 "2be5396be0f7e804ff36715b1d6a6019014ee066359c28e620d7b61790a130ae"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b879f36a846d9d6b4dbdc5d67fb28d3ee5af4b2f57d3d873f45a12e9b954dda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2d89a4410beec3bbbbea73972ec88406569aebc1d0e845f29115c61bbcec89b"
    sha256 cellar: :any_skip_relocation, monterey:       "3fde5a6736689ec5853b7c32ebf68e2b6c49dc4ccb46328904fa987fd2709a75"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6b26b44a94f55ed6db6995d3c64f302cd99f9d69f9315a3d399dd420f244ca3"
    sha256 cellar: :any_skip_relocation, catalina:       "66a967df63667b4f12183987201c2b2a71cc4f321dd926201f85301253c8f08e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d052de6d4e361979cd415c6bba7e9c2ef4ceb9c2cd04d8f8e009d4b1d73ac71e"
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
