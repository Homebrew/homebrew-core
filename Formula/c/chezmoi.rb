class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/archive/refs/tags/v2.60.1.tar.gz"
  sha256 "de4cfaf2aee8d2eaa83a4945253386991a08d3d2e9262846b18df3bfa0252419"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae0f10d56fa0675b3983792a6feebe4e36e9980a2fa748e413182679a3822807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58f2d03a3f3c972dc4ef40854fb2c8915ea66a7b0cc0cf25024ff2ffc2ee0e2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f478d7e24358aa896c9743b226ca90514d5fb61df13f7a7797a454f9d29c0c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca8e34497f52d94908b7fa58fafefd48bd32150c9501d337f4df547061198fb8"
    sha256 cellar: :any_skip_relocation, ventura:       "93cb8dfda26ade6cd1edbeeb75568fe8932f775f93b6cbc7cba2b36f8eefc31e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "142791518fc96a555bcaed54024bd33643db60f507e82fb0b877b85ad1101a9a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
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
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system bin/"chezmoi", "init"
    assert_path_exists testpath/".local/share/chezmoi"
  end
end
