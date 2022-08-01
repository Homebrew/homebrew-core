class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.20.0",
      revision: "774eed29f7ddb9c910534d627990d63182ad0304"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8d6832c00c11da38e10dbd2aba93b56d03c1dbed0b66c079cfd667e44093ca8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1edbaf78aaeee95f7084756fc11050a41e1f14daac4ab44ff4369b66ca659e5c"
    sha256 cellar: :any_skip_relocation, monterey:       "7a930d76a581747ccae68f902c4db292a33081e2f18b0b23ea41e780dfef1943"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc00a5d29743e765f62c06133fe9b85f771c4960e37eb2641d83c1ab011c3a61"
    sha256 cellar: :any_skip_relocation, catalina:       "cc5e52d2c06e8d4a6f1b4734c6a265545d7d52f10264bf6dd671933013e4b111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bf01f56fbbb2f197b7ff59c55d16a59bf566e93bad74fea46d1a5e4d2a1b8d2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
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
