class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.58.0.tar.gz"
  sha256 "90894536c797147586db775d06ec2040c45cd7eef941f7ccbea46f4e5997c81c"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3cb6b84271ebd44425139e995f6c11fb8405c73b8eebba18a2155895670e1f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3cb6b84271ebd44425139e995f6c11fb8405c73b8eebba18a2155895670e1f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3cb6b84271ebd44425139e995f6c11fb8405c73b8eebba18a2155895670e1f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b8a4655d289d7cef3471bb479dcf1bd3665440c3c9fa4412ac5f6e02450f849"
    sha256 cellar: :any_skip_relocation, ventura:       "c98643a52ed2ea1afab0bea2c4168b1d045bd21b2eef22c68e5706de7dc59c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b9c42f277d56692ac8a13af727eb71b6ad912c58700f0646d1e3a233586bba6"
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
