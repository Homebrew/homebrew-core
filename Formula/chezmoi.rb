class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.35.0",
      revision: "a642b704f0bfcff6697b30a6b3ec7a213a9ca0e8"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba9d6943760506ce777bb982562edfe089a314d4020077bda27c8ea96bdeb8cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05731dd514742181d422e67f9cf928cf4549805335ac4eabb9b07e0d8adab971"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8068461ac9995265344ed0c2d5aadc8e10ed5bdde234632a01864f085ff82e6"
    sha256 cellar: :any_skip_relocation, ventura:        "863671660688fd47e797759df92668bce7d567885145212a7aef3baf32d4a9af"
    sha256 cellar: :any_skip_relocation, monterey:       "42fb3caff8b5908a8bab5dfcb1f4f6063e5db6b390e80f194b09a4f72b13cd0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4d3832df4394131a217a0f1847020bc916248ae4488c679c16c30f27234665c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "222d45a2cb9d97cf7bc201b1ceafbef2866ecc982d8501a6ec2240850d283ed4"
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
