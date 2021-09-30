class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.5.1",
      revision: "94c53e6abc03d5c6734e2fdc2741291ad72bebb6"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "98c070da7f7a69959dbdc035fa1107eaa86cef4b09efc67fda922272b547079f"
    sha256 cellar: :any_skip_relocation, big_sur:       "4fb0cc53e95838eedf1d2b9e9e961448df3d97b69f109053a602dac62b0ce4ea"
    sha256 cellar: :any_skip_relocation, catalina:      "c41efa77ad77945bdc0b8fc2318b0465622863424d1163e1f145a5c5079fac91"
    sha256 cellar: :any_skip_relocation, mojave:        "f89824348c6ccc0174f57c5c6423d0161e26b3df70fd16c0a9fa7c527fa33dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47bceea9a98c964674f1b4b771a5e82e77c989a1b9285d2e2a7fc29708784e5d"
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
