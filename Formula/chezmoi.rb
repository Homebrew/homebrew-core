class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.1.4",
      revision: "cdbc0851550d5b5a1355af3640a3f9008fb59a61"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "97414ad05c84a2172f6a49fdfd317201515dbfe7de87f990e80c1306f672acb0"
    sha256 cellar: :any_skip_relocation, big_sur:       "c20ce92429c49a3f86a4e76d286989dd708c2f2b81cb80a2da7928e314f95c62"
    sha256 cellar: :any_skip_relocation, catalina:      "67c6c51aab58ce8281098916ad336f3decfdbee7e06c6633b395c1ac4775df0f"
    sha256 cellar: :any_skip_relocation, mojave:        "95bfd8ff42e4566a5cb56157a0a1d04226b57058fb216e6f401d730e59077d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9cde8b2ff8f35acaf09f01ef9abd74479c1ce7788c110c27d9621b9c1e1e3f0"
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
