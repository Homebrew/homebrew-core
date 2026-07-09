class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "f8d041c10a834321e9a5c5a10087f71b88aacfd885803e7b333e9df9452889f5"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84dadc6bb0f851aa6b5a1fc7159cd84c2e9810952b62ced5d2ee5a4cdbe62bb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84dadc6bb0f851aa6b5a1fc7159cd84c2e9810952b62ced5d2ee5a4cdbe62bb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84dadc6bb0f851aa6b5a1fc7159cd84c2e9810952b62ced5d2ee5a4cdbe62bb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cf3cf1703989ec354bb01ba005be81d8fe83998e17032a949bf603cffbe9bc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b6b3a3ce32090dd4208a44993ac93b484828593bc32031b88741336a7147a54"
    sha256 cellar: :any,                 x86_64_linux:  "8a06f97e0c0e84d82c967dd4c259767b444ed78ac6a4f19fc10cece2cf679a13"
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
