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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aeac91812cd9f7b37401642c8138620d5fcd8d52eed17d666cb6922946a24147"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d317751bd6062c0e0353635b782baca87b7cc8d8478b954b8c20ec2b39e4971b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8ef9c4d5dcd0f1ae0b2ffa9aa37b67b8ebea285b833f427a568bf18b60ec0b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "72e331a25c690f6bf440adaab644237d1150a311a5166b847e83bf37695a33e1"
    sha256 cellar: :any_skip_relocation, ventura:        "5a22109229b57ed2920e047e8c7c36870bfe3c462c4e2efc255976bf53e5bd4f"
    sha256 cellar: :any_skip_relocation, monterey:       "e4a420f8935cf8bc5412d4cc06f240f2e4e556ca95c4b5b8579b76a5986949a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6685c35b2755eb4475421410d3dc56be5b9ade94a7bdd6e297371dac630e286"
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
