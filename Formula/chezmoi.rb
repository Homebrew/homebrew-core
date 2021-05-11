class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.0.12",
      revision: "2256a83c51b97f4a326feb66fd3ebdc3f1833a15"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "97e95228e18f161da3e04dc33d9d3a2d265c0224f6b35590ef8a70a7b307a8d1"
    sha256 cellar: :any_skip_relocation, big_sur:       "29df8b350132784006af037b26caf26ea8f97d2b3a82f83623db6a09560ba68b"
    sha256 cellar: :any_skip_relocation, catalina:      "e3c98d0e8d838fb7a5eb081e074b869431850e04ba391a4e9a5280f0baa799ac"
    sha256 cellar: :any_skip_relocation, mojave:        "5beab703315d0a1d4e03692e546c1634d8317f4660f70806190600f1c2114d22"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{Time.now.utc.rfc3339}
      -X main.builtBy=homebrew
    ].join(" ")
    system "go", "build", *std_go_args, "-ldflags", ldflags

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by homebrew", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
