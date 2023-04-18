class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.33.1",
      revision: "bc4478d84f59ea38084cf7e58b9226278d0e046d"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc0224d0c28266fae2584212497c96440ce5dbee9ca52a6f2b149e9453d2e438"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30841b45390039846afc969828b801ef42bbaf6c4b22e3b6603b50c526a5610c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a317549ffb33f51af1c4babaf391cba531ccbb5a361055d166821b9644041834"
    sha256 cellar: :any_skip_relocation, ventura:        "db2050dd65ff00e5beac3ae6714a47b556642b3f160d61aa94e430aadc9570b9"
    sha256 cellar: :any_skip_relocation, monterey:       "17274add4bfb9323c4e320ff0cda20c0266dd53318158b57237b570e90ae1525"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8363f8e3e70121f03f8566a2695dd87c7cdce0d0acc00a56d9d3718bac40ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ff2659c73dffa0492c3ae34a8e3b2ad064bc545eb0d255ff3759ab6f410a40e"
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
