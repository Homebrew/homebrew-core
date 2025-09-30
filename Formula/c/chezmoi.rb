class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.65.2/chezmoi-2.65.2.tar.gz"
  sha256 "a0c96a3b38190abc00f4142e6b9bf73cda3ae441c99d0aca768a8a42656351c8"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bce3c6c8240e7cec1045b6a18f676881c1b2325a743954385e3783a3a52e9ad6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af5a516f562c7ebd602b4e794fa3dfda46a8029edd066ddd8fb82cbbf99609a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b3461c7585383fdcf1589713b32a83a2c6ee4f5b4a4bafb7d7310c3f8f89727"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcf1d959cc52066c8036eae5e27d3754859ebd400d548cf1a6b0eb1d4882d22d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e21522456aae3ca90f2f5ef0c6fd4c41f90f1712da9259d8ebd1da87d35a95e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4545651cf4f1d81d0fc88b7ccb3ff2f835984589f843106842988758ab36827"
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
