class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.20.2.tar.gz"
  sha256 "221380a32559984b64cdda81fabb60e5d4ed00db49ffe8390ddc149bef25c5a7"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "696d8f98191d8360836ae3a80a695d3cb497d4e78433105d1d44812f2a2d2b77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34d0819438fbabd70c231b185a8a9ffc0d630014ea27da5ee641f2ebd404c921"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "445007868988126eaf3a8d6cf4e3c319ea3ad71d5f780c464a6538f8152d2f25"
    sha256 cellar: :any_skip_relocation, ventura:        "6a0bbbd55d91512479ef8ab92ff16c39011e403f103b2263babf9f96782837cc"
    sha256 cellar: :any_skip_relocation, monterey:       "c385e7cc5c95268ca004bf0cfe925e9b0bba1e975b4e3dd46517c8092b70d2c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf56dcb93b534c432ae2483263fc3d7a987780c182433fd6be7242a6a9570279"
    sha256 cellar: :any_skip_relocation, catalina:       "ef84a020918b10e065771f01133770aae833ef065f5b608c5bd33bbb1cb7cbec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0729ef5de47db92c356c49280121435cd40ea4a347289cd2f4451a6feac4ace6"
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
