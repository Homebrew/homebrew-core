class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.10.1",
      revision: "6ed080bba2bd3f439832c2bd4b14ed2812c8ee9b"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00af7077f8df2997560ce765049dbf16f75b43d979c8a6286fb434b8cfbf2304"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62c794aab281dc85778cc2f076c5c5170282eecf9b315ec5a2fc713eace53b2a"
    sha256 cellar: :any_skip_relocation, monterey:       "8528c2eb6f4bfe76882249c79efa9d9f02e49861886abb754e109ca92be9a855"
    sha256 cellar: :any_skip_relocation, big_sur:        "72939a95081d59227f0ffa54ae784a9844b3d83ea44a5182a1b25219a08e0294"
    sha256 cellar: :any_skip_relocation, catalina:       "0c78cb486adefac7c9118556f64342820efe8012ce31e1ed0f44aa73788d5945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b57beba484ecaba2a3f3b0ca486c058b15b0132815a72c46112a9d8bf4cf2f7b"
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
