class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.40.1.tar.gz"
  sha256 "0bb2af951b4716067747184b5b5bbd90c270edee5b45a84e62a5a803bf7ef467"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e79de0269a413ce2170952d6d489f1efbdc455c91c21a266786b481f76fbe8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd808e7ab481a380bc2c6cf0e85bbe7403bd63c6a14db33ccd10ef0056b0bcd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f7780e9b53e2ebab114d1cabee710c01b2d25e3c1910e42b34595b584c62249"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a12dc3b0700fc711e8368c80f7c51952c60fe618e7222085071f96c1fdee7d3"
    sha256 cellar: :any_skip_relocation, ventura:        "cd318cebf06070cf4fc6d160614abfe19d1c63af2613560455365820617280f2"
    sha256 cellar: :any_skip_relocation, monterey:       "ef8269bdb74e7f3e0b5ded9146138055ee1b02b5894a64767b90880f90180dc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7f0b11cdb4cc734ba8e15e0b3189db91b854fa30f98308c77d2b0df748f741b"
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
