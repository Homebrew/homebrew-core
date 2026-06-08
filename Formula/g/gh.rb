class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.93.0.tar.gz"
  sha256 "8f3369ade41fe7a04ff93ec6029d5b0a8a94ccb4bb59f338d5c445aa695f0753"
  license "MIT"
  compatibility_version 1
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c15ca98ef2e2c53f085f2137d1b9ce9baa0ae3e0eccdcf556f7ac84fff4a2288"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebd838dccb32187e2a4243f27a767303c3a7dcd1b369c9801d1d9002fb01fb73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a4c0d5143944005dd35b5c42e13358a94eeeea890a86246ad819cb67ed4637e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a11bedc4a89b51936bca89f23a22da77bcfbc5232e9b41917bc76abad4b24215"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a67d6d93638a61932d4a1067faed92dba05116758c59c0cbe8bfdef08cfa064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "192d3379fd81a4cf45daa8b4d0523c7445094eabeab4ace7b02023a3f598728d"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    ldflags = %w[-s -w]

    with_env(
      "GH_VERSION"   => gh_version,
      "GO_LDFLAGS"   => ldflags.join(" "),
      "GO_BUILDTAGS" => "updateable",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install buildpath.glob("share/man/man1/gh*.1")
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
