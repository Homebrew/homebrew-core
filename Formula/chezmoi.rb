class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.1.6",
      revision: "1a9e2aff8c314571a2c8ce34677419e47c40da4f"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "09b2d96ede0d305d5942098f81ffa9580625d63d875d79a201b1ebd104590f37"
    sha256 cellar: :any_skip_relocation, big_sur:       "e67e6f6d98b925fe83424eaa74ccf4e7ffb4584b6780106ee863cfa83fa13886"
    sha256 cellar: :any_skip_relocation, catalina:      "af35cd0a6d4190b57371a38ed63c321c8be1b9a3b128dd656f7cbc5079a10a6d"
    sha256 cellar: :any_skip_relocation, mojave:        "15358de9c6a7501e78b72fa5cb08c959cd6428f9e33eb7a8b32d3f85fd1fec55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3e568d866c3554a730286b24056190777ecb3736edf5373d00c965497806862"
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
