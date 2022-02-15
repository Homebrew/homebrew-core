class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.12.0",
      revision: "9f01e42aef127fe1524969616555c89815454b1b"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44e3d6ed1f181c0c88a8de18e21fedb38d2ff1dbaeef66b55d39c658439793b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3bd41b50c4b8f8e6f87cac377f0ce5641e457783d8f6a16eed968f223e95715"
    sha256 cellar: :any_skip_relocation, monterey:       "5b9b519a5a62b7819573a9136ea4dcfe3315774d2c00fc7194350659515cb993"
    sha256 cellar: :any_skip_relocation, big_sur:        "c90e8ec18d12e2927d38354533013bff0dfcbf664af3f12dc07dbc5d85747187"
    sha256 cellar: :any_skip_relocation, catalina:       "722b46df598c082519fb5120cdfde23a7cf5e408b1254152ef70a304e6defe6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e82e8125abbbb15ad7c8da57e4669ea9dc04649fbfd32f9e88e0f8626d25e545"
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
