class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.49.0.tar.gz"
  sha256 "fc21c007219919da19f09180d3b966db95cd766bdb4123800d5ce292633a2132"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ba0ae0cb9d9b866f95df261ef7d53f0b87d16c16a99d85b1cf6f8550db571aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33aeacca7a9e0801c4d570c7b84a79025e70e85c7f220db310b932fd37ae9575"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a0abcc90de5c806053a377dbb36f30a09d2afff5dcf3e4672a9b3dfc99b0d70"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c5a8c717a602d2ce91ad049c258b8128f33fcf90b0f1c7c7a7d5728ac8ceb24"
    sha256 cellar: :any_skip_relocation, ventura:        "45f23f52de38d1838332bb3d98a70b033255431ee9a96b335e6a015b46552d04"
    sha256 cellar: :any_skip_relocation, monterey:       "a7e03a5415983ee080cfa0169f14db34ced03cc7640cafa61d5a74a517b96a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaf818fd94805ac1a774981e07c49e7fda3e6bdc807e6e816241bb6815d7ab7a"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
