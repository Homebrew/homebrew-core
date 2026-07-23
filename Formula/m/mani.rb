class Mani < Formula
  desc "CLI tool to help you manage repositories"
  homepage "https://manicli.com"
  url "https://github.com/alajmo/mani/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "7b061b6606aeb3b024d14009d9028c30b0b56d8d8d4078b39c8d87db696bde1b"
  license "MIT"
  head "https://github.com/alajmo/mani.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e336167638d0959a709f181cc49df2291513cb39c3695eae0fafec647ec796ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e336167638d0959a709f181cc49df2291513cb39c3695eae0fafec647ec796ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e336167638d0959a709f181cc49df2291513cb39c3695eae0fafec647ec796ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d0acfa8235e756111d56b4458d8c6e3464679c86bc1f404cc819b18bf11f6c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1666c0236bda8ecbe6488698b97c7208b02bfc50223f6c24fbfde5b270c7c7bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03277410ed2ad6bcd485125b3a8bbbc43cbe9b3a60c5d392f837d2b4c3b7a0ec"
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
