class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "a734a0234f365692bf9c45db62061e9a799781bac0cb6178b57ddf6f5c38dccf"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "406dc6c660bc041cf2a38e0a7cb1c8d698d5f398075a9d34d7612957c4275b53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "406dc6c660bc041cf2a38e0a7cb1c8d698d5f398075a9d34d7612957c4275b53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "406dc6c660bc041cf2a38e0a7cb1c8d698d5f398075a9d34d7612957c4275b53"
    sha256 cellar: :any_skip_relocation, sonoma:        "30d6d63d2f4be8f079a50acf92034aaddfa91b7624e042d7feb6f42b5e0eda37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eea7657a10917cfef85efd3fefaca4fc025c715b248a8fc35e06517123a8de9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6162e8f4ad067db8260a5a714e4d96cbe68bb1363c5eca4c2ed6023a54d37941"
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
