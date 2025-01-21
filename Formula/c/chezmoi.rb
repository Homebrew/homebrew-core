class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/archive/refs/tags/v2.58.0.tar.gz"
  sha256 "50ac56d7e0624c5b1df2f451fbdec5c46e0e381476e8f2212669840de0d42984"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5dadd7545a2e3ae52810a827b763b46f557bf96f75eb7052a9c1d6d50098604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80bb76cbe515ca0968e7db93077a0846bd2184b1ef61b85d864508e4bae58aa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c39b56190822d4d82e7088c41ee7a53ea84e01587c39eca887832b06cf2e74f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c9c3386f65759a3c67e063cc436b337ad3dbf4a21abea9eb130824a62dacf6c"
    sha256 cellar: :any_skip_relocation, ventura:       "133a1cd6a4268d4af9e82bcd5a04bb2c8c1d495579c97038c7b9afb3f3f12484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57563928e60eb850eb507afb1e1256db1ee384e6e14370ed4cd95230012c66d2"
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
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
