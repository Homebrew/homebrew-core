class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.71.1/chezmoi-2.71.1.tar.gz"
  sha256 "701dd96e91ca58377cbcc2886b936b0e383df1865aa45172160b2c9329ccade4"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73b069dd7658473287118b881a589ae01a8bb081aa216cfc7a241896f713e795"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "426ec228956312487f285aa9ba90a0cdaf70fa725e095c2e89f09b39c7e4c03a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0a660d7b1bede6df4ced76de8eff7d1305cac6693dcfe4c93e2667e9baac4b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffa2df02c917b8769e4a6929a926d669ec91c7c48aba4913d9f645a301e440a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9541587b0cc2bbba1223e7523a7f9de36d65066e51bec06e315ae8a85db80dea"
    sha256 cellar: :any,                 x86_64_linux:  "2490379cfb67399a537c40ec79f3bad2d64fbdcaec29eb12d466667f6ce9b5aa"
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
