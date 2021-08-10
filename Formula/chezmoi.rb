class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.1.4",
      revision: "cdbc0851550d5b5a1355af3640a3f9008fb59a61"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "07e46f48f1dafdd0e64f682bf126e83ce7e23dab30cae5edf8eb2ba1a0513003"
    sha256 cellar: :any_skip_relocation, big_sur:       "1925cbb25cb7541b49dc0f29dc048e18ef95f1a062cd2af03ad5df17a71f9d14"
    sha256 cellar: :any_skip_relocation, catalina:      "137e52b55d8f43d1a80d4c57ea9c576f21fa83cde88d27aeaafd9ef9f997e3dc"
    sha256 cellar: :any_skip_relocation, mojave:        "9a7edaf3026d8ee3003720304d16c10c2e97f5a6badfdcc8c25fbf1b0db9bc39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d653b223bb14c3eb61abc84b0ee61ca266177881e626da9de807fdb0921ff9dd"
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
