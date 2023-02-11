class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.30.1",
      revision: "ff0c704a9068c81b3ad301236d730fefcd9ce98c"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed9d5b512f4899ab61996c88992a002582a212319b92238c8f58a102a2244962"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "705129381fed5719b04a8cafc02167ad726e4736c7edb5db5983de518ce8eda7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a983d7a2c82c403ab35061f35136375da866f8c47828c03c4281850450589d10"
    sha256 cellar: :any_skip_relocation, ventura:        "36de4048d88b378a338a951ba1cbbeb6dab9e730d5bf6bbb2fedccc528186c79"
    sha256 cellar: :any_skip_relocation, monterey:       "35f35c902c7e66275f43f32b7579fb95f7c6def26907f09183ac5001041233bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "98c32deed51d3abcee5f0f9ee1ab90e2bfdd043d619123882f9d1afe1e12edd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a2e6524e4f12e507164a93fdc84a3b57bad50f3362efad0d7e06113b3951bb5"
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
