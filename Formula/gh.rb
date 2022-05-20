class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.10.1.tar.gz"
  sha256 "a94ba6a731ad558f7937d0ac46ff8034b56214ec9e24a9ad70296331b1bb12ed"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "049de180c8094f1d4dd375c02281e27bd6e32697f329e47d78e7a48339d87dec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1aa21d4313a551a3384fba9e22936ab811e3f250aacdd95fd7f979e195aa432"
    sha256 cellar: :any_skip_relocation, monterey:       "b34ba14a6359cbe623fb38ba46b1215f6a8582b914393122cb42f940ac3979cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "82468484a018b7ab5dd8daa831e4e2c40c22c2d2826a7b0c06a224eea49eebe0"
    sha256 cellar: :any_skip_relocation, catalina:       "df1b398630733ffb098f012b0af88c6ac5a6f40f3ea6a1f8d0234a2bfadc2b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3275fb7591057e8e0fbddd658cbb46b6bfdf51dc170c314e5b47de80745827c3"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    (bash_completion/"gh").write `#{bin}/gh completion -s bash`
    (fish_completion/"gh.fish").write `#{bin}/gh completion -s fish`
    (zsh_completion/"_gh").write `#{bin}/gh completion -s zsh`
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
