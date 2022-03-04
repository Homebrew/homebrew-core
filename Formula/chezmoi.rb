class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.13.1",
      revision: "e2e199bd48b9abb89e9a38fb2a5e42970e9267c4"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81b199acbf034b5f1ebe37d52b44cab09706eed5fd3d651a0921cb8462d72dbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdee4d81b682308e96abf06ba4cbd9733931a13a2c06fea756b1ce87047f513b"
    sha256 cellar: :any_skip_relocation, monterey:       "622bdd57e9adb1070769d18d5d963b31050f3ca016636a1375ea93300c451cee"
    sha256 cellar: :any_skip_relocation, big_sur:        "a72e8c775a9a17303d86b5587803858dbb6e01ad01c6997236d364defd212677"
    sha256 cellar: :any_skip_relocation, catalina:       "81634694d0e60a93b91abf8ed693579638f7879d884d2bf9bcc9d30e6d46d058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52a3043a0a7d5dd2e8bb0ab6a146a6c8c53e8e76c0d84aba513b9da4f9e083c7"
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
