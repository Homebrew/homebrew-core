class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.62.2/chezmoi-2.62.2.tar.gz"
  sha256 "92742fee8689a8b2e630be6dabf071fa1ffac3b473047129d531d974fa022190"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bdf6a1c2b097e62ce89a1e1ee2a4206b61a3031e8f041caf4796436ae509398"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23ba13181ec7b921c7d9ce6db7e27341fdb52bba3e9d2d01dea351932e349c05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2997eb8925160d500acf27b9774d47885062074aa6ca92750a11295ce300f9f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "36aadff4102ac243c568becacf907061f23c7e5dc3dc645e3153815be00cad69"
    sha256 cellar: :any_skip_relocation, ventura:       "8e2a2b0d49c3f9f6258686648ba80fdf05bade0aeafe7b11bea7fef4ae186830"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acfcda48be0c835247a0661a7609ab51d921ae071c1183dec529974fc7b1510f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6569672ec7c4b1483105f5f7f7fb4f20d39b60cffd6236c8935bca8bbdef2ca8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{File.read("COMMIT")}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bash_completion.install "completions/chezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match(/commit [0-9a-f]{40}/, shell_output("#{bin}/chezmoi --version"))
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system bin/"chezmoi", "init"
    assert_path_exists testpath/".local/share/chezmoi"
  end
end
