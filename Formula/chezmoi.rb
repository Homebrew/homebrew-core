class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.15.4",
      revision: "bec3d0a03a0ccdcd2f4be319568d764eff0c2777"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5395446ab76ee2c516b687e274ce43cd96f53864266387ae6fe5c7fc217eb163"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81d6cd66eb881a18579a1e2d6a08e775170471c3f168be1dc79235b88d42d627"
    sha256 cellar: :any_skip_relocation, monterey:       "0680723287929e48d2546eabeb62ea8dcc89397556e9fd77ff7513a14db31fbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "33a90eae50d7811f99185e8675be33e7821975bf4f45ffbc363dc69eb5fae7ea"
    sha256 cellar: :any_skip_relocation, catalina:       "636a9d77601e8e63bf81ac057f2aa0660b55976141ba80cd6177378ada599971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a75c298fd8119bfaf7779185806e0111300a5198dcac48f992b3b5268fac0e35"
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
