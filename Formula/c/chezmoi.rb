class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/archive/refs/tags/v2.47.4.tar.gz"
  sha256 "3f4575c54b5c42b90ed37ed05314235b0e455e0dd05cc63bb64f910924211803"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2737872e44db76b5cbd39ef39a27efa041b9db524da800467f47cce9149cea03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2ac47f8977c6ec72ad8d214e587c0d9ae1d71328dc9d271b6c2c12f01fb78a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac08f17a5f0ae126f61aab7c0aa497bab5c312585f53b443a28c15b49b52ddc1"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d721b3688c45359e938e40bd5227c92ab882043428b89dd66ff4cabf2aacdbb"
    sha256 cellar: :any_skip_relocation, ventura:        "82c51f43bdd022b36ea7010b9b70c926e0212d45a4531c3fd86fc8459b586002"
    sha256 cellar: :any_skip_relocation, monterey:       "8cf5f30baad57c9000123ae26d957d2e38234d1c82cc2af3fec9f86680bcf42a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5f33bcc48ab5f6c4eeea066533ae4f167646691c6802175eebf755c64100cd9"
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
