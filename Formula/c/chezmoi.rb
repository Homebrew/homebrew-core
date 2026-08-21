class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.72.0/chezmoi-2.72.0.tar.gz"
  sha256 "7c7450a69638494b6ff65625a431f867b2038cdab90b3104c6a862967f3bd288"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b28d05dd89d441681c454d4b56432563a4e28e8c2ab291864cc266f3c48f8cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "440b01e036be96b6d1e256f843b41671029828d52a973e81754a9819d3c189e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6da56d1e51421b0f7aa59dfbc4c2f7aa4cf9837f977284fac4f3619a8fe5381"
    sha256 cellar: :any_skip_relocation, sonoma:        "72b2a07bd19fd1b1b56138bf74ea20d4946603f3063fdf99892d59737257f188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33fbb2f2e6f54a11285e73b7b966b940bffd6b5e96150b09cc2912b1ca62e132"
    sha256 cellar: :any,                 x86_64_linux:  "044259c7293c4d87e2ea757c37125f3d6f3e445d4a290e7590b5ffe7c704f101"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    bash_completion.install "completions/chezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    output = shell_output("#{bin}/chezmoi --version")
    assert_match "version v#{version}", output
    assert_match "built by #{tap.user}", output

    system bin/"chezmoi", "init"
    assert_path_exists testpath/".local/share/chezmoi"
  end
end
