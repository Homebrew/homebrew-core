class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.40.3",
      revision: "294c2c8bea1d9fda0b14bd029774dc96e066c0cd"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae9f7c7cd2531d208b4832b228e4b981a40d955015a6139dccdeeee6ac4ab2a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75c3279025afe383b77f9678b9fefbfbe6e91eb1c9e556c580798066d6ded357"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ac1cdf0728188e154736809fa3d8dfdb610df9c4f50e46c1452c6d44c845ef6"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec6bbff59fa0303fef83785f9372fbf4940cef9bd6c6516dc3fa0b6306068382"
    sha256 cellar: :any_skip_relocation, ventura:        "1306bd71dcfd2dd223d83a9545b436c16830a75605af63bef8e2f8bfc8900dbf"
    sha256 cellar: :any_skip_relocation, monterey:       "8c4085ee04ba170e7594fa7ca2e1f6d24540f7742169be4297498850e9e3af31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f3a8b139ded482725f6cfc4f991a26305f1448941d04b8becc8d54b4973e009"
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
