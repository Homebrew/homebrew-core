class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "c8798b624064c2f32542f102a59ba4eaf95b1a3cb95a1205b0791d66e00778b7"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ababa5d790473a74cf9c3dca43993ee0bd94d0a9036698e1da0d6747220f7236"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccfb6c7fd89c29b2b78d727436d4c7d59774cfc442a04533a1921e72057fbd6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccfb6c7fd89c29b2b78d727436d4c7d59774cfc442a04533a1921e72057fbd6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ccfb6c7fd89c29b2b78d727436d4c7d59774cfc442a04533a1921e72057fbd6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "88da030307c20add0b8da1dfbea66af342b4def415f3c72acf0f66d0b623e9b5"
    sha256 cellar: :any_skip_relocation, ventura:       "88da030307c20add0b8da1dfbea66af342b4def415f3c72acf0f66d0b623e9b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18fbb36627f3da6e00e265f9870f2c535ba6eb2681cd454d8fa504898c8daaed"
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
