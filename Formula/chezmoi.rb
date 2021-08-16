class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.1.5",
      revision: "1a59ced6df2009460cc063e06310197c4eddf2fe"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b2beb0d90626a08df5558a8d375064f56abbf9eaaba2981870c38ccc2373bcfd"
    sha256 cellar: :any_skip_relocation, big_sur:       "b8a8d95fbce79cc1bba282814eec39459848085236102313de89a3ca564a95d7"
    sha256 cellar: :any_skip_relocation, catalina:      "7b883d6d3abbd2a7393851b7f3b7a3239ccd01083a7cd0d5dc49eab45d202215"
    sha256 cellar: :any_skip_relocation, mojave:        "176b87ff4bd1a1b8dab8601645cb6a60f0a67b11cb34b7ece533c67752a55999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a11ec61b6cbaa7f614b709bcff39d5a32cdd18fd95a00f9bcc2c1708011cc47"
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
