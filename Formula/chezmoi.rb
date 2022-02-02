class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.11.0",
      revision: "223f7111c2b3e6f90f4ac8af7f5ca0c35c9d4816"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90dfd7cf496181c502e72a758b51575dbaa82737c0d91ac9b918dae2201e3702"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36c3fa8ff6fcee3d51109c1fa9603c02e0edb24a6250c58c2444bcbbf0e25951"
    sha256 cellar: :any_skip_relocation, monterey:       "ea4505702a77e0fe652d5c6ad4a4e4090bb30b9c2836699aadd836838e169dd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "14af138c15fa0b16e9e991cdd6bdb28b9fa93529c6ff6700f4c301c0cbb9039d"
    sha256 cellar: :any_skip_relocation, catalina:       "fcb777a042e17afd9bf3d3b53015dd5f731f0201411ad96178ee7f38081d7101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbcb52644b7009e89410d6c32d5d3380ae46937d7ce13e8730a3bbca7643d951"
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
