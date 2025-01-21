class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.65.0.tar.gz"
  sha256 "af026f1b0368b1444a67a941f179ddce7e97333881ec0bbcb49fed29f4151241"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d968cb4fd20d0eedeffd6de72b4fcf90672037b49b86ea4f785af0b3ae93f90c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d968cb4fd20d0eedeffd6de72b4fcf90672037b49b86ea4f785af0b3ae93f90c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d968cb4fd20d0eedeffd6de72b4fcf90672037b49b86ea4f785af0b3ae93f90c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f71766ae5956beec415070f2cdca33552c19223feb5730530b1abe4abef467b"
    sha256 cellar: :any_skip_relocation, ventura:       "2475ad201fb3970f6e1b9d894c328073a7782229c58fa4022e9f8bdea9c1835e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9863a0c954e617b157c2563e7eed03a7d2e233792ebb79c87037dc1650c6270"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    with_env(
      "GH_VERSION" => gh_version,
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
