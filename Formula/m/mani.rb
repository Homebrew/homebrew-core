class Mani < Formula
  desc "CLI tool to help you manage repositories"
  homepage "https://manicli.com"
  url "https://github.com/alajmo/mani/archive/refs/tags/v0.31.2.tar.gz"
  sha256 "fdcf1b91ee8fb9403c9d70ae6703af05961df7b4daf906dee667ae31a6ee6925"
  license "MIT"
  head "https://github.com/alajmo/mani.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d573084e6d4a00365798968938d6cb0d957e723ad896e84e4c488a349b5c8d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d573084e6d4a00365798968938d6cb0d957e723ad896e84e4c488a349b5c8d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d573084e6d4a00365798968938d6cb0d957e723ad896e84e4c488a349b5c8d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "539aa443e9af06216928a8bc901a2c50f8d6e245562101d4dfc6b3a18200fed9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dfd71977a67ae334c5dbd39714d62795aafa2b50db3bbeb84c94fe161807ada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1514288eed4a2bf18a052206c8fccb47f3fbb0a83d00fe93ea24232da711d574"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alajmo/mani/cmd.version=#{version}
      -X github.com/alajmo/mani/core/tui.version=#{version}
      -X github.com/alajmo/mani/cmd.commit=#{tap.user}
      -X github.com/alajmo/mani/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "netgo")
    generate_completions_from_executable(bin/"mani", shell_parameter_format: :cobra)
    system bin/"mani", "gen"
    man1.install "mani.1"
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/mani --version")

    (testpath/"mani.yaml").write <<~YAML
      projects:
        mani:
          url: https://github.com/alajmo/mani.git
          desc: CLI tool to help you manage repositories
          tags: [cli, git]

      tasks:
        git-status:
          desc: Show working tree status
          cmd: git status
    YAML

    system bin/"mani", "sync"
    assert_match "On branch main", shell_output("#{bin}/mani run git-status --tags cli")
  end
end
