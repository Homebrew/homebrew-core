class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.3.1",
      revision: "b05d33932b57f5ca04332f4b75c3fbf9d8905628"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a35100defc5f7bc4dc31fea52a98f7847a3a2cdc89fc201a9eb6e83de3cafc70"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c36e169822082c8837f2d737333b0b98900a0777029b049a6e76792557aacaf"
    sha256 cellar: :any_skip_relocation, catalina:      "23de4fac3c21a8b854133039033328d7bd6fc27d9c2e10df25a4ebb682e3d480"
    sha256 cellar: :any_skip_relocation, mojave:        "90802efb9958bdcc4ad6fe263d96105eebb109f8348c76034f54f62b79522c22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eecdda547122c7e3fe94d6ebe54a1f9e35c01747a90582fcad01416bfa1414c"
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
