class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.25.0",
      revision: "b3a8879e30a20134c9bef48646055e57aa78d8c5"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "487520d3317b6237742f2c5b6a0dc2f05bab08425dab9b1a5d261ea6e1b5d9c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbb2d6996500143c69bbb1373ad9f5df12113eb57088c69cb0339c4aaafefe5f"
    sha256 cellar: :any_skip_relocation, monterey:       "74d88415df756e8e2a30a0c45e4e4876796ae0321aa7b791e28540b021ac4eef"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5dc0ffe426909f7ae57d6935044c57b79e918220fec2f2eb099d0fb16604b15"
    sha256 cellar: :any_skip_relocation, catalina:       "55c56e4d4aac82f3578ebae56b462ec5dcf06972888b0c56a07384fdd32ee674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66842ce1ffabc33f34c55d0d07ceadc97697854ec47d6aef5ebcd1646de5770e"
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
