class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.6.1",
      revision: "8d9a89b0c131e69fc97ecbb2279558e2930ae9e1"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22dd0c1b6aba54da9a065b244ea7ff54d808a06071d793998111e79eb982b631"
    sha256 cellar: :any_skip_relocation, big_sur:       "3197c40beb6ec614256ee2b3a469486785ba90359aedd386eee22ecf979184d0"
    sha256 cellar: :any_skip_relocation, catalina:      "0b49b033446409badce168148b26bb288d447bb14fed01df7ab0321b7a16cc41"
    sha256 cellar: :any_skip_relocation, mojave:        "c885c8f5e9167394c111075941d955392b247aa6b90f895796af5dea614a3147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dce0bf303f910d18ddb1e2280382cb1c5d01209d27ad78c837fb2e34ebd257dd"
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
