class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.26.0",
      revision: "2b6393e005972343a4aba3d57399cf4d83b2bb55"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21c64671c9253edfbeca34537f2cbefb3ced851e1028ed2be3884e1a66fe86b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8e4562b0a7d09c90fb7fba0eeb3f1426d69cd26e6e7f4fef53da3ca5b95db93"
    sha256 cellar: :any_skip_relocation, monterey:       "026a3c278c5a006ee1f9db59d2b80448f91e24c9043db2392e02fc95b5a434f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "57d14ec44016a93212ecef05f51b5e7022753c40e8866bd24b515266b27e8ca0"
    sha256 cellar: :any_skip_relocation, catalina:       "216260db80b497818f5e796b1bf41a6a15b0d61f03fe2814c750ab92215d3687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95203e3676d324036cd223c6898592891fb3c86775a5c731218636f8d0ea27bf"
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
