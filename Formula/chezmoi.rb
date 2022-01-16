class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.10.0",
      revision: "66837906121278eab501dc91b0d9fa6b1da2a501"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98ff67b5ebd1e03b00d282df00e479959b6d45e7fbcdc08e64f6a6c566651479"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9867f28982ea36709a2314ab3662ef5db2839444010250ee97bd5f9136862422"
    sha256 cellar: :any_skip_relocation, monterey:       "d2569761f148634ed8a7838e9e02157292da211e5853ebf239cc6c31f59aa638"
    sha256 cellar: :any_skip_relocation, big_sur:        "08b8c6bc05168d22b21f00e164494b4215003f19cd21c11033ca16e72d0d231c"
    sha256 cellar: :any_skip_relocation, catalina:       "1c8426da1b0ee974bfa4583edffc62afd8679667b022b5e1054644c28a76e538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4a18879913ac9c6ba57a2770a6dcc58a56969fc301ce2fb0e3ea67f7a2af342"
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
