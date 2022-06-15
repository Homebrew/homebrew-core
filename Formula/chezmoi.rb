class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.17.2",
      revision: "3cdffde28eb5c4d537ed68590fa3b34801188c0b"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "929e4da0f29952ac5f480515e8a4a75674adada2a6b1b87ccef4304301363481"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ba924b9fab60f8e029b7b0e32ac7097299ed86b7d56580916e4b84cfdc15471"
    sha256 cellar: :any_skip_relocation, monterey:       "8b57b5625897175206ff06a9f119a2d3b88d90d2ce27d3352358e780d2d3ea61"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e91f97fd77a6d2bef1333fd2727181cd0541f79e5650d3b12ca34b4ff2543be"
    sha256 cellar: :any_skip_relocation, catalina:       "6299e002b0908f3022d280dfcb8d533e48293a5c757f2d84b1b114262011b9ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05f7607c7abec7d89dbafa561f1893d780e03d2d38c0e6d1daac55db670a44e3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
