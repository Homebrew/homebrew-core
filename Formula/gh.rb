class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.24.3.tar.gz"
  sha256 "f5c8a273d3adabee9d4a07d38e738df589f1e9dcdae03f9c7b8e3d8aa4b58cf4"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ceb4fe88e540f7965d698f0db3c4ec505c875e76fc45edab74babb548c5c8f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ceb4fe88e540f7965d698f0db3c4ec505c875e76fc45edab74babb548c5c8f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ceb4fe88e540f7965d698f0db3c4ec505c875e76fc45edab74babb548c5c8f6"
    sha256 cellar: :any_skip_relocation, ventura:        "db20616ae553019cf404f805ef01459f9daed844b14ac3c18ee6f7be15919706"
    sha256 cellar: :any_skip_relocation, monterey:       "db20616ae553019cf404f805ef01459f9daed844b14ac3c18ee6f7be15919706"
    sha256 cellar: :any_skip_relocation, big_sur:        "db20616ae553019cf404f805ef01459f9daed844b14ac3c18ee6f7be15919706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fd409ee6ab37ea4562cea4a84c6c244cf6c3acae6c5e49d739ed84397ce9f89"
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
