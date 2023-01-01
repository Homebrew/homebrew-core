class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.29.0",
      revision: "ab39c1d8876b5339b57c4c639dcbea21fbf90c15"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4ac3cfbcf1781f7cbd9ca512f7744638fb0ede9b2008440ab408c379702117d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "795d948f6b18c9f772b7488a556a07618bcb3a5184b4bb1601e567c0b4ca0564"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e24afab315213122f82b35e2594daca066eac211a080dc5274d66c2426176b0"
    sha256 cellar: :any_skip_relocation, ventura:        "bd7a9608e193124519ded78f9bdac669d7d54cf8b779aca6988460ced720ed70"
    sha256 cellar: :any_skip_relocation, monterey:       "3bb9c908137d7e1cf833fbe9e1eebfd3b9ee8816975bfd7bae61206d37f864f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "7606a91e8656bd9edd8d2b090ce97150420ad7093da763456150e204addae4cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07b1c40d392d22eb5935d90f6ab14d84b96b1ac21bfabaf7e6ad66285b4189ac"
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
