class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.18.0",
      revision: "817d3e7f7d74970fecd80e18a55de3bae006ebe9"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b4d86582c0904df7f923c07a549caf210dce8a3a0867bf322db65fb1063fad5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16c64da3e5fed75bcb94e3bde00bb9ba005fff6439a2fb1f25c7ff20990946df"
    sha256 cellar: :any_skip_relocation, monterey:       "ddc66b2dc30bbb512dc7232fb45dda922511d2e54ba8ff18f89db18f7b1f037a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3302a034a7c754f638e90eb74ecee86639ef74b97142becb222d4cef585d040d"
    sha256 cellar: :any_skip_relocation, catalina:       "4c5a3f3243b32661167275277600f5f5071cc0bc5070e5f4fa904f23a0b3f62b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6442750ab7de3ab8e3b78caa81be3cf290766c1b2db5d7eac94bedaa6b21967"
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
