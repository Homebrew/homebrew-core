class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.29.4",
      revision: "492e102f767199de065684d4a9ef6604dab3e11f"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df7ef42fde4e61e5beb5c18593b295bd29e8899c8c22908ae9392c61cb9d4b61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a22f7fd73da6c6f5d000d200169b4edd6127f9854f25fe39547a8f01b3d7de63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa6d432c35e259e520b6a7d6887bdf399f29ff8be95cba195d17a50f4bdfa376"
    sha256 cellar: :any_skip_relocation, ventura:        "eac98d11559e849aa2efdbdba797dc2f648bf003b4b4a68dfb58424d55453b37"
    sha256 cellar: :any_skip_relocation, monterey:       "5ef4e62a2f561f2ddfdcc68d1f839bf227f7532e7b2f1d3c56f77a8ebcab42b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "591f05bd28b3f7d6f1906f557b6e00f18874b02e80e7d6830755951cf8d483e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecfbbebb131405dbb819e3dd2e888ff3ddfef864969fba33996a7e0388cf3e99"
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
