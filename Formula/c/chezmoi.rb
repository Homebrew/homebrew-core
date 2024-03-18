class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.47.2",
      revision: "f4904293d9e3d5297f481b0b1ec00981716fff39"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "361c0ba829b349a31ffd78a6cbee10bcea516ddc9783139a90170763b40714b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c046381f9da66094eef750b3f1d92e7f27bb9f745a28c66f678dffc9cff3605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41893ae143e3ea51c166e969f1d3904295c4cc8ba22f6bc8e33fe08c67552266"
    sha256 cellar: :any_skip_relocation, sonoma:         "54dbee97f6e2647313f5a7fa681020233babe16724cee706ef769ddfa02f5c62"
    sha256 cellar: :any_skip_relocation, ventura:        "5dc476fab1c3d5bb4a64ec2fc974bfc7bca860a5b3ceeda4c250a04eb8ced472"
    sha256 cellar: :any_skip_relocation, monterey:       "94b05b93c510dc2fde11587bb21ae0c4ec3af0c9e53a2af2c3005a125e67cf95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9311b13f3be29e85c493ec5e08a15fdd696e2d154ae4858f67400b0f1ff15be5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

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
