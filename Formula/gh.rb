class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.18.0.tar.gz"
  sha256 "313eaf102339535fb73cbb3f2cbe7bddce96e5323f32129592a48536cce950a3"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c1aa715651c2a8b03b159cb4bb848e4bac7827f0993e23cc1a330e78d057e16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccd3a288d36f3b98d66634d2196500565adbd4da5042b809ab705ae21c2681c6"
    sha256 cellar: :any_skip_relocation, monterey:       "45dd9d5844970f0723f6098ed01b8661be0c05cac0a322ee57325c3b1354b3c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "abb725d3612aabcbd2617cad1c36279d424e4381578552807b0de1e0bda76349"
    sha256 cellar: :any_skip_relocation, catalina:       "748f8a37d15b5e8db3e07138568533598ede2e79c10c8341cbef1f61ad963041"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a93ee6ac267dd23b73c1accc308de1219c7968ee4c1ac5b33bc58dd9ac2992d9"
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
