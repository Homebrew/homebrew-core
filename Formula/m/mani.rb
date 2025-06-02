class Mani < Formula
  desc "CLI tool to help you manage repositories"
  homepage "https://manicli.com"
  url "https://github.com/alajmo/mani/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "dd44bd7f409c5b2a755beca45229cbc9be02712be55c099bd6a01f6cc3441df2"
  license "MIT"
  head "https://github.com/alajmo/mani.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2df96b3f4f0206dbf5571b270269341d3d0c62e3c29826b682107501551a007f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2df96b3f4f0206dbf5571b270269341d3d0c62e3c29826b682107501551a007f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2df96b3f4f0206dbf5571b270269341d3d0c62e3c29826b682107501551a007f"
    sha256 cellar: :any_skip_relocation, sonoma:        "26dd3a03b1e5519eaa222b13a63617d03e89dbc771cd8c2ae50906e5bac2b38d"
    sha256 cellar: :any_skip_relocation, ventura:       "26dd3a03b1e5519eaa222b13a63617d03e89dbc771cd8c2ae50906e5bac2b38d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64dfe83672401b0bf18860dd973a212f6c352517ca47f2955eae2a32ffceb636"
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
