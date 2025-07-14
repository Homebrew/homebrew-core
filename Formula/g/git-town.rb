class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v21.2.0.tar.gz"
  sha256 "e4193ec5d8a7f9e7ca22e12938ecab81e1d6a61a89eafc698e8b514204db7068"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ac53c2b57809516d79635f4a0f93a8aaf5636cbba510587a121d65dba647ef5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ac53c2b57809516d79635f4a0f93a8aaf5636cbba510587a121d65dba647ef5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ac53c2b57809516d79635f4a0f93a8aaf5636cbba510587a121d65dba647ef5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3763b95321afeff90b3991d74f24c0425b8886462833fd27463576d7332f5ec7"
    sha256 cellar: :any_skip_relocation, ventura:       "3763b95321afeff90b3991d74f24c0425b8886462833fd27463576d7332f5ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71d43eb431367565ca602f41c2162de3052d7d62667dd3f4a842b861884bb860"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
