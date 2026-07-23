class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.31.2.tar.gz"
  sha256 "4ffeceee75f4c8a0c1aad15d723c61faadc8ef5d845b1c6222670308a8230986"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb8551ca6936bdbc4bc94129769d24211e96e5a1e630df5ac6e52fc8e2405e8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb8551ca6936bdbc4bc94129769d24211e96e5a1e630df5ac6e52fc8e2405e8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb8551ca6936bdbc4bc94129769d24211e96e5a1e630df5ac6e52fc8e2405e8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "34f5db2d63506b75bfb2c56aba8dae2efbcb3e66fdfdb2b21ac9683612708bc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1b6307e89a5f71197c1d568be0b455a76693c460fb113a1c35db94c770d6755"
    sha256 cellar: :any,                 x86_64_linux:  "7ec2e4b7d6d4cc5b75e5c36b42d352ac049f1fe37cd35fcd1be28b723f7cb7d1"
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
