class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.29.3",
      revision: "fec55002b83b3688d13988055226aa716b0c7c14"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8efb217012484117ce390de8d15af632c790c46f12be82e5d4ebcba017acf9c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f640d608f3358ba71fa1d05b7ca03999f5005e6b8d20b52c87217f2ee43694c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb107e1e3f928f464e638324dd30928bd1e0ff2a93cbc326fac09295aea4b47f"
    sha256 cellar: :any_skip_relocation, ventura:        "6bdaffb6ec111b5b2817b22a26e435338a3153906192731ca28b373b29bc5994"
    sha256 cellar: :any_skip_relocation, monterey:       "9a5b379953177da2aa340258017892f642ca2b1e2e893b412f95e1de39eb5d3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "414cfabec946d6d6526bf1ff586ba26fb6eee8c669a29d0f89cf2d67284e9612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09b34c1142f9396d5bc71993fb5a955bad0878bb94793eef3538b81595463f73"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
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
