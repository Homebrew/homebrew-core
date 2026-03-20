class GitSpice < Formula
  desc "Manage stacked Git branches"
  homepage "https://abhinav.github.io/git-spice/"
  url "https://github.com/abhinav/git-spice/archive/refs/tags/v0.24.2.tar.gz"
  sha256 "6605166dc47b179af0d3e9714dba83254b633e78d6b0bc2189592c5067b0ccf2"
  license "GPL-3.0-or-later"
  head "https://github.com/abhinav/git-spice.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "377d48138de5d3a3d0957305cb1b52d83db9126d9d4ec3145e0fc883ba0cf96b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "377d48138de5d3a3d0957305cb1b52d83db9126d9d4ec3145e0fc883ba0cf96b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "377d48138de5d3a3d0957305cb1b52d83db9126d9d4ec3145e0fc883ba0cf96b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d655c0b65bf4d3a061f7b55ae16530585eca0fc8b5d45f00255ce1355b41a07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de2dbe8a6bde74014878969036a97710c9f7ae34b3fcddbe0edd3bfa91c2beaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a9ee526792a2ae72bf7d38728e2455d9843482481bfbe45a570ea2bb8b21c20"
  end

  depends_on "go" => :build

  conflicts_with "ghostscript", because: "both install `gs` binary"

  def install
    ldflags = "-s -w -X main._version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"git-spice")
    bin.install_symlink "git-spice" => "gs"

    generate_completions_from_executable(bin/"gs", "shell", "completion")
    generate_completions_from_executable(bin/"git-spice", "shell", "completion")
  end

  def caveats
    <<~EOS
      The executable has been renamed to 'git-spice'.
      To ease the transition, this release also symlinks 'gs' to 'git-spice'.
      The symlink will be dropped in a future release.
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
