class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.1.3",
      revision: "4282879e3a7b1e19d4c501b5867e4f2d4f4cf548"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea12dff2829c249c6d506a0f4f4fa5115b82bab6731cec8a718e41f6aba83352"
    sha256 cellar: :any_skip_relocation, big_sur:       "c39c3f2541dae072d5c586df92bc38acb75ee79e4b4af69625068c9ef6576cfd"
    sha256 cellar: :any_skip_relocation, catalina:      "5fa40b3e8a68167007c3b79fceb2e044c9b8c73840a06e3f2deb26296a2a9994"
    sha256 cellar: :any_skip_relocation, mojave:        "e70add31679b47be38833810639b477f6da8556db6fab4ba8f58eb50c58811c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1028f72362507c2e6b5e75b01f59b6d9f0211e4ab8cd27580847e8d1bedde0bc"
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
