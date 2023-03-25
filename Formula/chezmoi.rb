class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.33.0",
      revision: "ced12b81b493670520b177dcc62de2c67172858d"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b24d93d7f5c2b4547b309c9c9911bf8b6fd8321fcdc70df6649efbe6dbddfca4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d95cb75412d1dede8d6ec1000142fcf57ee91fa3bd737442a7ed15973873853e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0ea764f8715cbf0265f992149d2838b7c929eb54dc145775d4cd797bced8c3f"
    sha256 cellar: :any_skip_relocation, ventura:        "6471903e1f4968293764631e3a6ffda2923d3caad48afc89e5a8170abd3090d3"
    sha256 cellar: :any_skip_relocation, monterey:       "3032a39443a3ff7ca4851aba426b892ebb6adef5b3e61e0427ccb46c539015ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c549ed818b91c9a6827990e503f91275378e0c3a68bc1f3be2bfc7cddc7cdce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7c8923b76fd895e44bb878dc0ba0e2bae07d41fbac4eb2df62baad9eb201b4a"
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
