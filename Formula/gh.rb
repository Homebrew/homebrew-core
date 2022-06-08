class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.12.0.tar.gz"
  sha256 "e231636aa516802500107726fdcca8c3290db4d8efb20451b0b2008e9e83d4ce"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f50f21d3d37706fc239d8e8d4534bd0eb845a53a82bce1e65f88c0dace2fbb3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0b5dc2e081cd7ab2301a5191208fb6c1992c280ff2e2334b0d6f20a8d0a582e"
    sha256 cellar: :any_skip_relocation, monterey:       "0fb7d15f05e68196d3345b332395355e297bced8c5224e5e80490493969c5443"
    sha256 cellar: :any_skip_relocation, big_sur:        "f01cffc185137a5e187aaecb26ae629133070465e15548a4ae98c20b8e4b581a"
    sha256 cellar: :any_skip_relocation, catalina:       "1e115218cdc90006d275c09a50ce533cc51408a9705442a5369dc931d28c17cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5d3554f07e29265a42386d90e7a253d90c23844b7a68cd704a45cff500b81b8"
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
