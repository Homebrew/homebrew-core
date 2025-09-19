class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.65.1/chezmoi-2.65.1.tar.gz"
  sha256 "3a86f151e6b6d4b06b8ac6216eb50519bc63e3b542a78ac29271de6de26f3980"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdbcf15a708822a2254f193eec7bf6d19d9184afbcff09743344e4cc5c627493"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64969c20b4c526f0957b67914e692c38180ed8521629010c50b5250dbdaeb3f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3615f907bb78b8c555f1441f89ff31311b1ff47e07903604bb0541e220f36753"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db7ba8e70684f20d1eec7762d896116a784cda056c9edffddaccaa0327218c75"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ced0db510a42fe4ad4f30877a80eb9d3aa8916ba5365ff989aa16369ce24bee"
    sha256 cellar: :any_skip_relocation, ventura:       "52ab1c85a6254cc3bae19e802a84a0632177f2815b451207580535f38103d1d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "662a99cddc61b0a0e5de3580c220819cbf5bad642fcffe0f0f711ab506af9905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "615be391ead9097d42c972aa56fcf412874b0228875a69ba4f372d65e027d38d"
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
