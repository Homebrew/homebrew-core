class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "8599c2ffb3b04f391791e6ae9299ef7355474bb3daeb185800a9bc008bce7f6e"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8795da7d9bbb5feb6911fac8848f7ec6c290691940881d0afc1f2313f5466859"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8795da7d9bbb5feb6911fac8848f7ec6c290691940881d0afc1f2313f5466859"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8795da7d9bbb5feb6911fac8848f7ec6c290691940881d0afc1f2313f5466859"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaac1d7f3d8dee88aaf7cc7b4d0140780c8f4dae49485d00bd14755ec7297479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d8b10ea2b74327034c9cef011a49fa09bd285d20b982523f63e192dd215c408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e7a614625439a660d3ac68df97675c4eac4d8c76731fc989a622f3a1fe784eb"
  end

  depends_on "go" => :build

  conflicts_with "ghostscript", because: "both install `gs` binary"

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"gs")

    generate_completions_from_executable(bin/"gs", "shell", "completion")
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"

    assert_match "main", shell_output("#{bin}/gs log long 2>&1")

    output = shell_output("#{bin}/gs branch create feat1 2>&1", 1)
    assert_match "error: Terminal is dumb, but EDITOR unset", output

    assert_match version.to_s, shell_output("#{bin}/gs --version")
  end
end
