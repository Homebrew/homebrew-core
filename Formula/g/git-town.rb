class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v13.0.0.tar.gz"
  sha256 "9033df3a55aabb73af79395a4d628fbc65fa79169e43df4a2a8c866dbcfdd500"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0dac7dba597c3574e3044838ef5d70d72459a94fb1046cefae159e86d3b5adf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d03c5b8daf3c56d836e1c8afe006c340f81750f04426a022d3c7f59e8c117960"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4225325812de062b6bf4ca615b4c9504fe2b1cfc7ede48e011bf724c2c4c9b99"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1448f632996ca223a9bd1ad136f9ed065b4a856c0ec8d3755cc9426a59ed072"
    sha256 cellar: :any_skip_relocation, ventura:        "e178b6fca74525ef29bf7bf17cfcb2f797441da7769c8951006e70ccd2e5a3db"
    sha256 cellar: :any_skip_relocation, monterey:       "22ee79634143885718be402e99cfc96e6d75e1ab3d0cd1fc1c94b7a59cb0c962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bb56f27a6bd0e5f195b0f6cc33f388e3f61733c61b82a34c6ec895096211e80"
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
