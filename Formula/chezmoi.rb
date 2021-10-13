class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.7.0",
      revision: "bb5f4a3c641faee14e051320a63999370b54ba6b"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "24ec3b7b0b7b3a3d302404f7641388daff5e779424df9396304e417c6cff3e7f"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f5219876ae495ca604ebccb0c2b4bd7e0f9e3e940dc676e366785f7c4982b58"
    sha256 cellar: :any_skip_relocation, catalina:      "3fed29e3bafc1ad8a365b89c3bde4cbd4ab6063ad625c85a75fc365c68383bdb"
    sha256 cellar: :any_skip_relocation, mojave:        "84c6c7d7c3691ed7b9d1fba0a4729f2fbbd2dfcd984eee6327785e02fb25ad17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb920993377d6c635077dd2c6f798101da201d3b543de0f0395c86da46e048f9"
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
