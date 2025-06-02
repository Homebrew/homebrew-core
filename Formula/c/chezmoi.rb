class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.62.5/chezmoi-2.62.5.tar.gz"
  sha256 "6b15bfe9d91b01a7bb54101ed4d5cda650cb5b8fc2ec5b4f75152cd03dd5a09e"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc53ce92ebd493ba043659e090b1b515b792a7e26acd319334c8c64675bab0e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59dc097f9be8f97521bd23c18b5d1de36361ded44890ff78d873525143a2bac6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "726a95d1b461c985d93316753f47b679d37a4cba9317c2bae01c6dc128887b3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "abe59e6715252a6fdb9e81cc0d019f35603eec764c989e35ab8dbcb29285cc21"
    sha256 cellar: :any_skip_relocation, ventura:       "56a62e1b6272d452b8c4a503a5ab9175572c50809ab5aea2ba4bf97442776cb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad037447f3c29194d11ba7b8d4418e941e914326f803c2c21a23172df955958e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0eb0a389279048717f3d7748670c0596ee418041d62f10776f894efc415a831c"
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
