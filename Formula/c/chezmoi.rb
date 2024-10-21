class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/archive/refs/tags/v2.52.4.tar.gz"
  sha256 "9fec62659d91a035c2bba3eec4f78e6e42a8bbd0551d57e302b9463ae6ab74e7"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9376cb85b14878d38e6742b7a5b34c97e958b16100be1a578a9d4f7072b6d0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0672f89d0119470daa5298e48a003e10174f1b695122cd728b0617a30e41c6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd1fa1247f45ec84fa73b9bf48ccc1513b2835bd9fbbc9d296ea24a2e7563ce9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6f8a8bd408abed04aeabd572cdf69ff5cf83003b8d6310e2bb0b45c9b3a8f4f"
    sha256 cellar: :any_skip_relocation, ventura:       "466ffbe96e942a541dd694ba9ec1190ff9829821e512c4c14d62dbe79eeebaa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e2edfc142581ed3aed77600590cd089ae26e26a1302bd9b0165466a2f172f49"
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
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system bin/"chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
