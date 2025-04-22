class Mani < Formula
  desc "CLI tool to help you manage repositories"
  homepage "https://manicli.com"
  url "https://github.com/alajmo/mani/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "a75984fda15ac431424964fe0a1d2c936e123583f2482eb3147c1ef20ba85c80"
  license "MIT"
  head "https://github.com/alajmo/mani.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "066be4f13259634fe85d0a18574c98e6b275eaed65ca124f5c0e339e88497a07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "066be4f13259634fe85d0a18574c98e6b275eaed65ca124f5c0e339e88497a07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "066be4f13259634fe85d0a18574c98e6b275eaed65ca124f5c0e339e88497a07"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a55190358a002ec44fdb57444ce463a5e185654811ab3bd6928618bf51a1880"
    sha256 cellar: :any_skip_relocation, ventura:       "3a55190358a002ec44fdb57444ce463a5e185654811ab3bd6928618bf51a1880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae89704ef4652bd3516c984967682192519dbdf4e69aab4317287166c6c288c8"
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
    generate_completions_from_executable(bin/"mani", "completion")
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
