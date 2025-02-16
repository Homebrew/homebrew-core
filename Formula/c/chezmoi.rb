class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/archive/refs/tags/v2.59.1.tar.gz"
  sha256 "577bce7c9038ca17cda2c61c1ff3df90c4b366b68629e3056e274cf4b319be30"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "460e05986fe1ba3fbd0c192c1ecb7bfce5308c32cf6f6ef2b561bbde705cff4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a61ea8a40fb33c7faa5e5d4b2e58ff4ae15a064dc6df2be556a4982c50ec21b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3f1db987fd46c94ab9d9ce44dbd1d3674e5e62ae74be092c6ac3f8106c17196"
    sha256 cellar: :any_skip_relocation, sonoma:        "022f84046b7fb743210b1b6bcf1f67a417a91e338d022efa636877b69ca4c57e"
    sha256 cellar: :any_skip_relocation, ventura:       "1832d07037fcae815b1ffb4b871c1ef0546f92b6ecfda2f1b5a5c75c84efcfca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ea389db95ac860ea7b4db90f918856dbd7f04767426a64944d0ed32b9fd2ea0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
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
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system bin/"chezmoi", "init"
    assert_path_exists testpath/".local/share/chezmoi"
  end
end
