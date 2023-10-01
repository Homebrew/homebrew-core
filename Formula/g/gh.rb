class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.35.0.tar.gz"
  sha256 "ea94a1444bac2f111519f96904cd981bdeea6d40dd947e27a10b7b85e7891b0c"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7a6da5d934a5ad0660ec124a3995b4dd18a27a6da6532e1881f36e65bbcddb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a96c8a08558fc48df45de2149ff6d0fe11e4628da5451ba5c91a116221761f04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d28d628b393e8edeedb5b06c599ead82f071a0e3844837d58884f095a2777e55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed1021da6ff37ff5b35e73e55c1733d949d126af8a9ac344c327b841bd6b7d4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec86bd47e4b645a95f9088a0b1a3c7d3fbed3158b9f361a89afb5d8a49ff5546"
    sha256 cellar: :any_skip_relocation, ventura:        "e6e48fcda77833de8b236e1ac8a0de2c7604206cd96c7988dd9c9fc69602bc3d"
    sha256 cellar: :any_skip_relocation, monterey:       "a3f0705282b55d3c78e66bd80ef38e2b6ef59dfee5185ec5626a8ca7c38afefe"
    sha256 cellar: :any_skip_relocation, big_sur:        "df3e928799bea2d9ba43905300d8cf992967828057089026369fc6e2e7487d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2036ac2ed49fe24306f7c3fc38c9d02fc8203f38e91d84c0617a535520210e10"
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
