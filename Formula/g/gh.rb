class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/refs/tags/v2.38.0.tar.gz"
  sha256 "8ba98b5e46526c9828507a587b429448fe9436ce1f875aa567d77ec3a8cae56c"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a45091ca9a15d19eea28d739135ddb35982bbd20ea186811658111e2bf45a49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3889896724f6388af8b44259e8a2960c3ff35dbc74a4c81ee12a4fe65e401c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea6f3f76bc04d9142eb2b3930c88d833dbd8e0c38103a4124c880b536c975444"
    sha256 cellar: :any_skip_relocation, sonoma:         "a98c5922707167d04bcc6cca2f355720b7cc68a1304e4c53902e68216672f726"
    sha256 cellar: :any_skip_relocation, ventura:        "e4af4867a88bd4dd045c7e9817b6c6d1fb4f69f0d6b8a41336807550afdb9f4c"
    sha256 cellar: :any_skip_relocation, monterey:       "0a1d2f52aba655bae25317714334c2e275800138a0a81f956e5ef0869f55aad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fd996df52bf6c372cfbb2847f6fa27a8cb3e2c87822a34cc960842a10699e91"
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
