class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.1.2",
      revision: "a3fb755a88315bbdecedba3d849324752989400d"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5ecc241939f0c3234a231de818f56f9d259bc1103d9602290cecf41b65592e2b"
    sha256 cellar: :any_skip_relocation, big_sur:       "3e69dd67c0c6fea3d179ccfa8395d27e35e07173dbb02c27f1fcc0cb36874398"
    sha256 cellar: :any_skip_relocation, catalina:      "7fd3de47c770604c1e60d6b6b7a975bac5a31919c1488d079d53d273803b5420"
    sha256 cellar: :any_skip_relocation, mojave:        "e3d78a4bb29786b9805836be39923866d94cb124be3e49119ff4593c6d32d5ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00f7e9ebde588f633cfb3903cb92644c4ac96451d48025be7307ca2b0446cee6"
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
