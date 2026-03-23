class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v22.7.0.tar.gz"
  sha256 "0f9ce5332a9c0c8107e67183377f2842d0dcb3e3f3bf9d61f6083e2630a29205"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26f02e9c7aa8db56c15bfe977c6521d00d8516c023f444527c74b08d309ca300"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26f02e9c7aa8db56c15bfe977c6521d00d8516c023f444527c74b08d309ca300"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26f02e9c7aa8db56c15bfe977c6521d00d8516c023f444527c74b08d309ca300"
    sha256 cellar: :any_skip_relocation, sonoma:        "0210aeb260dfde572b181bdb3afec8afe246d825b28c2beb2cf2596db3805496"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "947c55a5332d12dba1b8867a4306d1e1ba78a00c7b9449acb8f5f3c8dbf0ed57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8de4a8b8c7b1803a246441507bca62a12a3e51f054633cf91f15c388ee9fdec"
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
