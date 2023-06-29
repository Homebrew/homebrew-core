class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.31.0.tar.gz"
  sha256 "9a9896fa80ecfec640cf5d93da830713150f4b44e0db142c958bfa36d09d2c03"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0873700f81cdc1f5291df177bbf8517197d0eadc348f63e5f095f09746e9b4a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0873700f81cdc1f5291df177bbf8517197d0eadc348f63e5f095f09746e9b4a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0873700f81cdc1f5291df177bbf8517197d0eadc348f63e5f095f09746e9b4a5"
    sha256 cellar: :any_skip_relocation, ventura:        "ce0a677fcb78e368cdb856178538e4cb3ac91d2a68e0702e806d2cb11f9d3350"
    sha256 cellar: :any_skip_relocation, monterey:       "ce0a677fcb78e368cdb856178538e4cb3ac91d2a68e0702e806d2cb11f9d3350"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce0a677fcb78e368cdb856178538e4cb3ac91d2a68e0702e806d2cb11f9d3350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4b9deabd779d1aaf5519e93030c4ab50feb713f3333a1fef9ee82ffe9192642"
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
