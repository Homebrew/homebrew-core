class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.15.2",
      revision: "bf0c9bee555f1de78cd003638621fff375a26867"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ee7334bb116ebaf11d9d9c844643e76774ac25ae5656e63bcba3f0292477d5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "125a9fffaddd26da5f66fa42e136160f089242ceaae9eb1300044fe34b2749fa"
    sha256 cellar: :any_skip_relocation, monterey:       "28f25bf9f6e64399ecbea35afec397d87a458c04df3da80aae26ee290a1226e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a401dc2cf471b24d0e6e6b1db3eae29d608da5924dc78ce9fd494ce26f7751bc"
    sha256 cellar: :any_skip_relocation, catalina:       "4b88e7563d4fcf367ddb2e4bc4b4faf0f3c3cee9628c1aa7ddd3faa2fcb7a581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78af2378cba0d4fef11f99af0f896563ba8cfa824c3a107e15d869803cbe49f3"
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
