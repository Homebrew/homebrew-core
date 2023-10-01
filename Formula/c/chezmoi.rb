class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.40.0",
      revision: "6a8ca1634654734bb33a036ffb9c21e6b9f4d28d"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e8b651e295cf9aa2e729eb20a95369f40776c417967dfd548a8d099814555e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3110d532bce9e4b491947ed573cb8791b2e9686e8bc48ac3c9254c7821191f64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d4f12c92e13b30f16f8590d3baf2f5023411487618fe95d56a97498719d2ca8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16b9f5098a7341449a6117b33f1d7f3c81e2bbe7931483542c61318f5dabfb95"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8fea089285495c752425255a1f7991a38db1e7dccbfbfda1d80d292f1eb1375"
    sha256 cellar: :any_skip_relocation, ventura:        "317ae3c957e7e47c9da148810cf6552806ada43bd64e06717a8d9d4ad29d34a0"
    sha256 cellar: :any_skip_relocation, monterey:       "fbc1730aa793c0cc4eba55de4ba917da49ab0a5bdec7f5fc6dd2dbf1a11cd74e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b103680ce7be96687331e6e4bd67179c36c029396e445ed4da28db0e3af99a34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4033bf4f74a71d34ab9cae2a42572182c8e2f54c9c3cc8e959da6b41482b825f"
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
