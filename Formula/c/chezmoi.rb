class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.70.5/chezmoi-2.70.5.tar.gz"
  sha256 "670db2ba9f2ea8613856d6cb07a7787077abb28883cbbbc90f7130d9569fe8fe"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "922c5047e44079d27d9645aa43c20be01152dd9f574a33858827b992a10f0fd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c775bc51e367b2eb1e0a836f7361575649fbb86aed79f78d3a3a10998377f63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad5eb2e61c37821a18bc22395bd62892172cb3f1d16367a11cbde3436cfbca39"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee44b47783a7827c2f5a5882b4b2889843e54f0600b0f3bdbfc4487f675c3d9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f85ab1152e9421b9bb9b2bc63e90957e2cacac8a7886c9349062c269e44c0a38"
    sha256 cellar: :any,                 x86_64_linux:  "836159de40322ee75f4638767d4ead4c9637737d3de2c906f2ef4a45842c2c12"
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
