class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.9.3",
      revision: "c33f12d2853bababe24e7e57a2554e40f785915c"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6b5b2e5804ea0d420ca6cafe7e246b070e4f8183391deb9df121375352b18b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46d91a0977a2c625685458524251babcaf99d20b4aa7280405e227dd9e0cb8f8"
    sha256 cellar: :any_skip_relocation, monterey:       "72d5525844a45c41a67b9a531696fe268295d2e75610b8f88dce3db6b7f03974"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f8608925b36fa770c793b1ca83fe3041814cf44d45c9dc758fb16843b498a0c"
    sha256 cellar: :any_skip_relocation, catalina:       "f52b4f3ede135244f3e810e834d8a19c82174da286587f979587696fb07b54c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2c54fc6f722abe5c5018070695e72c076d9e7600e5172f529023d8ad2865233"
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
