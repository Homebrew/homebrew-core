class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.59.0.tar.gz"
  sha256 "d24ed01e5aa1e8f42b397333462f9cd5c54e4845a5142044381fc8eb713fa001"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4db292686e8c16f6282f60ef492e3986e1407d6b6d1675d8588218ee20032e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4db292686e8c16f6282f60ef492e3986e1407d6b6d1675d8588218ee20032e42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4db292686e8c16f6282f60ef492e3986e1407d6b6d1675d8588218ee20032e42"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e5921393887a7f1bc8fb36176f1e5e252040386b750f3cf207f7bab5ba21338"
    sha256 cellar: :any_skip_relocation, ventura:       "cc34fd3400d8736dda6a193b1a3b973cca18236140d6e867151a38016becca88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0631067441cb34c73c660f73dfbab885167c3ac5b1f8ade765b14c5ebdbf0f9"
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
