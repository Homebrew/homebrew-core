class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.74.0/chezmoi-2.74.0.tar.gz"
  sha256 "737a86cf1816331665ce44a503307beb827bcdc7f59a321c13a75d4bfe96c0ca"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b04fc243e1e9143c88480d4d3bab671578678082d89a8735efdc4a19f9ffcefc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "925bc98de5ce8a24b2ed6fb3e572f6091f006376349733d14c16901340a5ce0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "95dca8882c7514a9ce6f6e446fefae0b6ec6611da915007a96c7cfd11cbd95b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4a7e7f168d4fac72bdd732c7ccb4937d1aad4992d95df58778ab01a918addfe1"
    sha256 cellar: :any,                 x86_64_linux:      "4768d049ea5029ae621a4be854c66e25d10a6f97b80c6467630a8602b9ef37ba"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    bash_completion.install "completions/chezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    output = shell_output("#{bin}/chezmoi --version")
    assert_match "version v#{version}", output
    assert_match "built by #{tap.user}", output

    system bin/"chezmoi", "init"
    assert_path_exists testpath/".local/share/chezmoi"
  end
end
