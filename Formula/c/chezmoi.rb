class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.62.0/chezmoi-2.62.0.tar.gz"
  sha256 "049557125101b3773db455d5d7a279097f79d9a074c5d2e51d77109b8d97e33a"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0798ba9952aeb97ccbd3c096bd8d092f1267de1edd0b25bc7bbef0398cfacfb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95e7510c2448132820e34ac6ed9925166bc2d79ef429515dbf2e1eb9cd33b14d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "085d092695abdb947ef209ad76cd9cf1d5ae9d4fbadb040008185f7978cbba99"
    sha256 cellar: :any_skip_relocation, sonoma:        "4eb35f75f542d7f73b7f80917c4654c844448a33be5642720d579982aabfabb5"
    sha256 cellar: :any_skip_relocation, ventura:       "7699ae0a5019e518857fc3415e8510b819f1b582e2b87609469dbfbc89b5e716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5605520948af18f257c5c97c8a9022e7eec984d94cf2ea508c6df2a6f0345566"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27e989894171d2ae8f3ec37a84f09b4450883755f9b1e7065201ff792810a47e"
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
