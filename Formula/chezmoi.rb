class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.34.3",
      revision: "439ccf8f4f092a3b1f909e430775db933dc7c740"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f8f0130a139a9a59eddc9aa051ee17137917902dc4647f390a796f18ac856b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c14c85a3a5c9b0cc17e11328e65e97bc340d4a0ebf9c4ddb9b9cd18e54b52f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23f32e9fa76819c68eae583cc28216035fbbf24b59372d0400b5df520c63f613"
    sha256 cellar: :any_skip_relocation, ventura:        "19d833151345c98a502d1bbbdde4ae39c3132230cfd1ac1dc1fe12b7e2762b8b"
    sha256 cellar: :any_skip_relocation, monterey:       "0502829c6c8a428a472479338dc717ff909e47c132c20d2535e63b949901a261"
    sha256 cellar: :any_skip_relocation, big_sur:        "5258cd4105411572ab6ea5001c3e8697ee5675b386110b782bc9a45c0674d800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a974b10d0d965bbb91e3f59c91b7170bbc69f57fd84fe5a45b4eff9008ed7e48"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
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
