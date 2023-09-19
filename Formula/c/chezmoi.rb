class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.40.0",
      revision: "6a8ca1634654734bb33a036ffb9c21e6b9f4d28d"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "20fed592de1018cf860bff0b124102f1ffd3933ec52ba21a16376d8fe3cb569e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2610e87b23b7758b8731c7b579e2f92446477a93f07010c8ec2972ed002660d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01d2f3a63c12f13e54a077899c145b15d5efbf398e31addf63e0735ea5227c21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c8481a50f7a066c9cdea7d5bdf93c62508abacb4fdbdb27dc173b3d7b54c921"
    sha256 cellar: :any_skip_relocation, sonoma:         "aed243b878cde9ba1f6bd52de32e0d5262813419136d6969cd9be49f60e7de86"
    sha256 cellar: :any_skip_relocation, ventura:        "16d86af48098252e099f88651286187f71112c01d8773b72babd217dd07a8fc4"
    sha256 cellar: :any_skip_relocation, monterey:       "8f4abd2466f9b64783eecb9519775342016af35436e1470ef22ec65a31b4bacb"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec40751af2a9d3a891be0a907eaaf7069494f7218db3ca06fdf3db05e9c9009d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbfb09b335668fa9bd2348d1444d4e892486052955d90c00eef8b34c1756ae50"
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
