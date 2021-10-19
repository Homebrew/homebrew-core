class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.7.2",
      revision: "ba9f8d31ea8542df2b51d00d927b301100cb1689"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "514abdbe3a506315c1fb87f299cfe29a6478f2a41d8aa1410b268d184380bcf7"
    sha256 cellar: :any_skip_relocation, big_sur:       "40f853e9a525b506b102d8e57ef18d0200b776e99e5234763c4a4c7ef279fc5e"
    sha256 cellar: :any_skip_relocation, catalina:      "f6661a18f910ba65c479ce066c66e62591d6edec7c6ad0b467393a0953ddb87e"
    sha256 cellar: :any_skip_relocation, mojave:        "d1e6504276c69e5d1bcde780655894ffb119f064b70a9ed5a3b36933c2f1fe0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f6bf18de16a56032fc0768cd30bef9c7cff1091c4ff482f072a7efed5a0ae75"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
      -X main.builtBy=#{tap.user}
    ].join(" ")
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
