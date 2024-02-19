class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.46.1",
      revision: "c65f66a5f1a990ffeb4d7e3f53320cb061f91513"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f45ebfca6c8c63504ae82f6e2270092db5ce00bf931b542ebe8435873d53567"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b7fa7a183335e427e134cb4a3bab742b565fde674c0e54611c40493e284e707"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cead14c9da6302def23df6c20bd994a590b546b94409a109da910eaaaeb0bf5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "98614e6e36d412901c3d1ac0fe33aeac5172680ae1d0188b77d1903217e38571"
    sha256 cellar: :any_skip_relocation, ventura:        "452dd87815053bbafafaf9af09f893a65e1228a419e0b7b8f04cc1836201c66e"
    sha256 cellar: :any_skip_relocation, monterey:       "63a91d5127ea245c5c01a9648482f43f03442dad5f5d4a47e1f80633385f2881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4e5bb13cc908586056fe86b329e7f04c59bced9a0636c983f472a23ba7481e8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

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
