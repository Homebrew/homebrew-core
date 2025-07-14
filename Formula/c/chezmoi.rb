class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.63.0/chezmoi-2.63.0.tar.gz"
  sha256 "3d66001de6022e7c4f7b587cb68fc8097215165f4ff37e6a6398b9c2097c3f94"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db4a329ad4653ccbd1d3bfddd09ea45cbfb443f030d8c4040143cedb1811f498"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d15b6ad287aeab57cd8e5f118f8c36c80ee0574ab1bbb47e63fa3a554564b17f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09956573f53dbd741b33c78414c2b8753299838aedc079cd5d33664c46c3bf31"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b252a7f7fb4e86d3c17ee6572944550e951930dfa42cd360be89c571850f54a"
    sha256 cellar: :any_skip_relocation, ventura:       "7f46303e3c7725f4d10cb2fc04ec6ec6140a4bcec1b933619db66c1b38480178"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b354f6ee1d97ed17ddf48cfa5873b230d07622ddc3cc517710a9d5c59208852d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30d5e59c020436d5dc509bdc8a1b8e20e9d6a6af045a4f4903527f7b9cb0ce25"
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
