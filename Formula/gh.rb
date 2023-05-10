class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.29.0.tar.gz"
  sha256 "f77718f109ff5817cde33eb004137f58bdcd5934b921aed1440c6b3e93e1df27"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56f2cd6b99a2531f8dfc3f85b42e9a3e178ae3baf203cbf7f33503a811db98de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56f2cd6b99a2531f8dfc3f85b42e9a3e178ae3baf203cbf7f33503a811db98de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56f2cd6b99a2531f8dfc3f85b42e9a3e178ae3baf203cbf7f33503a811db98de"
    sha256 cellar: :any_skip_relocation, ventura:        "af9c5382cac78becb90a51c9f177911c0e3ea396dc14e915a060cd8b896a6a33"
    sha256 cellar: :any_skip_relocation, monterey:       "af9c5382cac78becb90a51c9f177911c0e3ea396dc14e915a060cd8b896a6a33"
    sha256 cellar: :any_skip_relocation, big_sur:        "af9c5382cac78becb90a51c9f177911c0e3ea396dc14e915a060cd8b896a6a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a83fb0e3f862ea1a98cd2079c675a4bca35b425df2280180c0536a1d9741d343"
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
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
