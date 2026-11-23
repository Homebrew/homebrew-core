class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.74.2/chezmoi-2.74.2.tar.gz"
  sha256 "93aecfec5f1d55081ed4507f531db7de5a18738d6cb368b8cce827a37af18256"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "5904c6dd2867847f5213f25b316b759e17554a9577e016167d8c362fffb395a8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e5707cc43c9c1d200aee5ba8cf431beba96769b9d5f04e5a3a9165018f2cfe9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e97d5e12439e146df152b081284498980cea190d1b93e72c17ba4c5fbad167e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dec36f9c0ceefde588630729b311a7984073e69d5eb355cf0c1be1c60a35191a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "86278c8b4d8d90fe1d66c19d43db4cc2ef0ebc0b9f94891bc288d803b9792b49"
    sha256 cellar: :any,                 x86_64_linux:      "65000453ede8c4665e6a692d6a8944257ac107149dea362e0ac44e7777097132"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
