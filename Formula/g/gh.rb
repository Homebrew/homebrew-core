class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.46.0.tar.gz"
  sha256 "663871687310c671ecc183a258fa573622e1e972c681982ac79a25c967fd40b2"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da6339a487fa934079af693684e2c32a4e7a7d656f91a7298a751a3b429472b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d34b260e1d59b7a21f87095c9bd69c14132064286b54c0953c1f380ceb2d7fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80906c71cf3c14f415397f59133ef55cf1b2564b47cad61617b4870ca647030e"
    sha256 cellar: :any_skip_relocation, sonoma:         "aeabce24856f2f1534b925a87e11d1db6ade50230d39e0a7168f40d747b175d2"
    sha256 cellar: :any_skip_relocation, ventura:        "9d943a8ac3c2ddeacee150274bd32860b6e6228a7b58951037b2749c4ed6ee2e"
    sha256 cellar: :any_skip_relocation, monterey:       "720aef66253213d1b2a09ce52ac9bb002919974c90d6427f22dbef8a758c97f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b23ed390b178b2bd77b2c9a8be2a3b885358a5189039d735459f858072c5d8bc"
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
