class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "566392c06016d8ccabaee4a3d66ccd8372c749f30b60c182364e4ff12c23589d"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16ac88b7a6e919f1cd9dc5738d7ac3e979dc6f75d05d0d9b75d0332a11712976"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16ac88b7a6e919f1cd9dc5738d7ac3e979dc6f75d05d0d9b75d0332a11712976"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16ac88b7a6e919f1cd9dc5738d7ac3e979dc6f75d05d0d9b75d0332a11712976"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d061e54e9715d438912910e8391009c2c38795cf06a92e235f6523aeff49df3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1acec749c7766c512fbf2934fb4b8652fb4fc400c5c1aa241fbc8047d0b1a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46df786e1000a6b0cfe4b2ce38287a8d482f0e874aa69107fccde23f457386d1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"git-spice")

    generate_completions_from_executable(bin/"git-spice", "shell", "completion")
  end

  def caveats
    <<~EOS
      The 'gs' executable has been renamed to 'git-spice'.
      If you prefer to use 'gs', add an alias to your shell configuration:

        alias gs='git-spice'
    EOS
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"

    assert_match "main", shell_output("#{bin}/git-spice log long 2>&1")

    output = shell_output("#{bin}/git-spice branch create feat1 2>&1", 1)
    assert_match "error: Terminal is dumb, but EDITOR unset", output

    assert_match version.to_s, shell_output("#{bin}/git-spice --version")
  end
end
