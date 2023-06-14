class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.34.1",
      revision: "38846a481d93ea762c599144956b45c86305f47e"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67e16e9bc9cb4b68c747574c40dd5443cebe3c60407e7a166217c6d5436988f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2484b8c456653688156c3cb2a571c710097b37241028dedb2c7d9635dc046708"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4db5c4c05f6ea24e960dfbf78aa128141a48297b5575104f7f8dc574b9c73025"
    sha256 cellar: :any_skip_relocation, ventura:        "85087593c8d4b84f7f459775483a6061f4c4f3a3162ecaeab46e6b9bf7267df9"
    sha256 cellar: :any_skip_relocation, monterey:       "79c267e5c54cc39f00f70224b51b69dbf05f2d7e99df74581ee2b099454c8e40"
    sha256 cellar: :any_skip_relocation, big_sur:        "50c14e4943601f56f2f206ac66b5040e431c13079304b3f4ef43a7b34993e9f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b00cb70fcf7fe329116091d0c9e19199df99569d11937ecfb0cd0e39f9325132"
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
