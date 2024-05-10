class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/archive/refs/tags/v2.48.0.tar.gz"
  sha256 "3034a37ddc21fd19e9a37297dd98a6edbf85e68f112cafef721d2512fbac13e5"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13a325d306782eb2edbc6eb4a264da38459ac31db996f51206d36b9270bdb75c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ae4d75066856841772974e4ebc1d2b82de767d05150bfd0a52d7a13cbaffae6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07d92e3c0f39df8b2b58c608666b754ce4321f3214ccd1dbda5a7935218edf8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ddf675039497850bbd1ca63fd03f43718a1a3f870f1185f3aa8607e22c5e1e4"
    sha256 cellar: :any_skip_relocation, ventura:        "22d1a287a204debd0a02f3374fbaed7913a14a33354510481ad4b3f0299f5154"
    sha256 cellar: :any_skip_relocation, monterey:       "0c0a870dce81a80f7f91629234612cc52e88aaa52a3fbcaf5a8562428479ac89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b09a91c752f8b1ea9226f4930c1d0f88b95e416e0ef62774333209c9e9eedc3a"
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
