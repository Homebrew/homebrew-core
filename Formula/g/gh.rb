class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.51.0.tar.gz"
  sha256 "babc66157676eadc30c150ab9151981792796d6f24663cebc6eb070eb14c390f"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85b3ff30728ed342b9c8a404ae4d5be24b89c323bcd33d65eb146222a87f2846"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a09d46164ac499022d05b4745003e91105f4154a0ec036d41b4828352f4853a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6401171dcaa61b4fc00deb73787dc3b10b94845758e2fbaf93c20122e5b7d7c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "38fc0002f62cb5950884e759f4ce194607cf5ae8946d57b9e511a8fb25a7caf0"
    sha256 cellar: :any_skip_relocation, ventura:        "3b5fa7dab2b73f1129bcf2cc0cd005e3b91227526bb61eeb92f1825f7e7de529"
    sha256 cellar: :any_skip_relocation, monterey:       "2fd725f7d095fcb0c7c8efc9b17ef01ca7a11c24b8d23ca73820a05878a5bd04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f1164afd49035e20a591dc1f6b761f616a8323a33804781ddfc63495acc6895"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

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
