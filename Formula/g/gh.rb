class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.32.1.tar.gz"
  sha256 "1d569dc82eb6520e6a8959568c2db84fea3bbaab2604c8dd5901849d320e1eae"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b867c40c746d0b318121569a7a66571a3a0e45f707faed6cc799095ce02648d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b867c40c746d0b318121569a7a66571a3a0e45f707faed6cc799095ce02648d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b867c40c746d0b318121569a7a66571a3a0e45f707faed6cc799095ce02648d5"
    sha256 cellar: :any_skip_relocation, ventura:        "7ecb5103bc66037e9598c9beff428ac3f95a42771491d4ea7dc83807109efc01"
    sha256 cellar: :any_skip_relocation, monterey:       "7ecb5103bc66037e9598c9beff428ac3f95a42771491d4ea7dc83807109efc01"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ecb5103bc66037e9598c9beff428ac3f95a42771491d4ea7dc83807109efc01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17fba89d88216460c9587e515a20ad02da283bfb46f915de85e6c48deb18e27c"
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
