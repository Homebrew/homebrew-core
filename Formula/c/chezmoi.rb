class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.40.2",
      revision: "9f20f698cdb6bcdce7c9f5995bc382658eaf923c"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5a388e8e25dcd2a554061cfaf5f28bf1a41e7f5d472fc8701c46ba802daef78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "329d10a137f1ee1d44a03b31559759ad624849472c058b4e6386b2824fd775bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34ee080b75eaa84e759767826c24713ede376bcd14b06c3fe31db0bbe7ffcbe3"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab4d5bf0896f1a53a6d8bf1d76253597aa8cc1a1f4be1d72099adb33d675e71c"
    sha256 cellar: :any_skip_relocation, ventura:        "cb0301a83f374e7713041913b85b59b8491f80155ef48d81b6531ef43ab843a8"
    sha256 cellar: :any_skip_relocation, monterey:       "689d0be3028a2c793373a95bdeb4ce2ed129b527163068480cd86ebbeaa33515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee3192a932bf927aa47665dd51c3c71ec0d645e99f2c5804bb1ca83dc4b5bf1f"
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
