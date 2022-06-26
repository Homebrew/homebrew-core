class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.18.1",
      revision: "89f8b0ea0aa4e3add6e1bd2706d3db22373968c8"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d9ddc70c9e675345a6b32e904ca0e8ab7d3271cb8462bc39b36d62112385621"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc6d681e1ddffce1b1fd92b91facbdd5207882ad662c14a3aefa0d8d8a927e9c"
    sha256 cellar: :any_skip_relocation, monterey:       "b4ec9d4b9f6311a5536d1f5471b033e8f6b82eda86872c6c352c42f5e1a0d865"
    sha256 cellar: :any_skip_relocation, big_sur:        "c22778fe212a04002ce9fa05e7c5a458685c0364641f25e320348cc64d6de2dd"
    sha256 cellar: :any_skip_relocation, catalina:       "96b3870a78a351d9ca511f25432570403f2d8ac59fda44ceac7d4547ee11828c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b791d08a2003ac634c4fed8ad8e96532b94737ed041ad5f253101a74c11c90a"
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
