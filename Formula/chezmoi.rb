class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.4.0",
      revision: "0b2692ac45e43405d65a62a8a5fefb51ebaab9c4"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "db273bed59aa4e30078cc82fd354b6d97109f77e52dfb73f115372ef428c022a"
    sha256 cellar: :any_skip_relocation, big_sur:       "f7db175afd790bd8804a158ee091c95b6984535f1661f2648f7522148826adea"
    sha256 cellar: :any_skip_relocation, catalina:      "ed935b005ccd6502ca96cf3378af828de9642c81149ca4dca831c3ec26f97bdb"
    sha256 cellar: :any_skip_relocation, mojave:        "aab299914cb451ef4d872a430080de2a3eb411a6f76523d9fe785a3bff4acfb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "011f809569100fe37f6838ce0340967db0db6e00a737e192727b9f2fbd11e03f"
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
