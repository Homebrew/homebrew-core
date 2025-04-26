class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v25.19.0.tar.gz"
  sha256 "3179bf993c5ff6e9e48e8c37f355ea0634e42980f613c0a138d3ab437a59e0de"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "307d831af918f9c02a48e2d90265dcdc5304eaa8bea88c27a4b6cfa88bd8018a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31d101010327d74d0ffba568d3ba808ab96d53dca425396219b2c1b18bac6090"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8cefaf7e61b2271e09d1ba1d0aa44bb29844deb28371b41d7e6756796505639"
    sha256 cellar: :any_skip_relocation, sonoma:        "39438c93ea1489802512e05d0797b3aef21fd1bafc28efdea1869fed2a4efd7f"
    sha256 cellar: :any_skip_relocation, ventura:       "9bb685c1029395391fa7985e15c3a409e7e55e292bf4a01b820da5e5e2c0793a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c231cebbf2f62572ed04c551b5d07f5ffbe3d4279f5cc4862109f177a5d213f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
