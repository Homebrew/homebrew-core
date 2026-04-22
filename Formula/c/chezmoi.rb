class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.70.2/chezmoi-2.70.2.tar.gz"
  sha256 "b7d65d63971a757bbd4f0a02de619b09e85081afbda42d68eb2c7f7a7d01f668"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18398c42ba283d80e3fda08014ae067969840000dfabb6cd02b457a78243ffb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "126324c1a421bb926634cde08cf6a78ff13aa823cb0f216f26c43cf7c3ca6043"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5efd37eebf09c53157620e57cfdfdeea9377a02c00036ac7492975ca6fdf7091"
    sha256 cellar: :any_skip_relocation, sonoma:        "287c21dd8904268a8c804880ed82349bac0402d33d445131e26423507dbd168b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d16c0251b59ee845fe6eccc500ba757c25e565cf2c1ebe85afc51d21dfa8f54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a833c27994f45e717682f6b5d7d3b6359e35b239da7d06e84043cd609a24de57"
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
