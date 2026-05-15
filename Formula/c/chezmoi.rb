class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.70.3/chezmoi-2.70.3.tar.gz"
  sha256 "57a6f985f74f3015ffbe2bcba72db551f2a711c0504332148c3ddcd28f877118"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4446b47397d5b392c8b7a9ddfe4a6c04a41e2fe4dc52aac5110ce9f8b4c45bc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf4754b55768cdc567ec3724035a0b40fc427a332aa8953ae80aee607030d1b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4918d3431e1a9eac0a023cca522beae8799b6e5df58724b727325f21a284e3e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8b88aa07b7a48198a9b35e8d73a76afa877da5596853feebcd7c9a365b7e558"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fee5d27b8faabcf656dbc8f3d8b5a108b5f79048018e8a8922f3527f9cd44b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "080dec3d1f0f82827a0f141b9031f35ca3274d7cbefb121689a0e8d33f503dfc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{File.read("COMMIT")}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bash_completion.install "completions/chezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match(/commit [0-9a-f]{40}/, shell_output("#{bin}/chezmoi --version"))
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system bin/"chezmoi", "init"
    assert_path_exists testpath/".local/share/chezmoi"
  end
end
