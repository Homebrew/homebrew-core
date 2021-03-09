class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.7.0.tar.gz"
  sha256 "8d737d4e4a2943ca6e08c030c0992468162de0fc1366862d101b8e1389bdc36a"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1575fad6e5dda0241957d4668b04802df7d5a963a93d213471f5f89730d1e260"
    sha256 cellar: :any_skip_relocation, big_sur:       "88ab0ed37b4050437aaaac46fb444a001b86b024afd04f9926c5f479d44d6a7b"
    sha256 cellar: :any_skip_relocation, catalina:      "9399e8ca6bb5c0621c06d3963e28db01a9de4074f729054315a048272de3555d"
    sha256 cellar: :any_skip_relocation, mojave:        "c0dc5b0ddd5a30880be8e162bf9c2cc51f7057707204ae2af3b999715d371537"
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
