class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.70.0/chezmoi-2.70.0.tar.gz"
  sha256 "59d6e999c4abcf667eab3edce8965b4ba56097afc04405b0ca4b95145428296c"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbc20cdf8ef6b6796a6b2aa5121b6657d8c924df8d062e335a62454c61d9cd94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20f54e9783a2e102bb85b7ea7c4968f12db3929735a967414438764dd00acfab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79aa32daef332f1b8d681295c9918d88696bbe8e99b01bda6bb59f3f1bfe2492"
    sha256 cellar: :any_skip_relocation, sonoma:        "2330cb80af9286fa87d928b5dd634ad88b7011c00cab9c0cc6f552be8b45a6f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e1207ff04158d21957d2cef601a886f57cb6dc431b032b3e3dfccfb5229cfc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da3b1bac3b95b5ebf39e6ac6602f0a592b079a4e7f8cc0c20cb17bf5061633de"
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
