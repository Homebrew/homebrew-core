class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.22.1.tar.gz"
  sha256 "09cdd1c435d453a0c610f407979ecf8d314aec41d7b8004794f136f05b0fe688"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ee1220663a7f459ba495a75f5215b03842fd3caf5beab88aff11930fcc6304a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59e24af3e37f8af5970a42dd7e95a1797457cf0a80a4d8567c0a395670c97d39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40b13605bfbb68568dfced72ab87c599190d42f35e1e115d996fd75d44f015bf"
    sha256 cellar: :any_skip_relocation, ventura:        "3e72858f084a4dc5c7b9eea721ab37f6accf674e68c4c144f49650412451e6aa"
    sha256 cellar: :any_skip_relocation, monterey:       "ff2024322cf04fd532404f30561d09ded34151a261c7fc5906e035a5645aee64"
    sha256 cellar: :any_skip_relocation, big_sur:        "fedb18a375923bea01c62c32abffbe2b357c55f4735453530340c0d4f83ba588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da4f12836a7d4939a61ea5fd3526876884b84b41d7bf9a4b5dde7418a1d8f7cf"
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
