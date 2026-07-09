class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.71.0/chezmoi-2.71.0.tar.gz"
  sha256 "6707ab8a4404fc02dcf610e84247ef23d9187fbcb11423ec67233b7a6d6c8ba4"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd2645ec241bc7937b2316b9c71822abbb4ae06522c643bf84999bcc3f928f03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "625f6731121518a087ed2fa9b0b0a62872c84e2d4f8905cc4da8e5163288fb6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ded93ace8e6f1e3b9a56e11620d85f2deef410b1f193698c0bc4892202e9135"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f12d20281fdebc8fd9151d00d348f21d9ba14f292477d118a120453e7682f9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7999f02c158b470d0f844a3fc9a28b050681d3fedaddaca5702cbe8c909e13e4"
    sha256 cellar: :any,                 x86_64_linux:  "ccfec829a04e348f6896608e5dd273481bf6ea01f4066fcb39cb8394ac286acd"
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
