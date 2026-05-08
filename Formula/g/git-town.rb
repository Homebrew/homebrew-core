class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v23.0.0.tar.gz"
  sha256 "14c04f9ed0416797627dcb51fdb123a664bbf54e6c8066d383b4fb45cadabd9d"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c3e944c065f076c4e5d7db907f30d61e03805c50ecbeaec7b2536ef43ab5955"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c3e944c065f076c4e5d7db907f30d61e03805c50ecbeaec7b2536ef43ab5955"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c3e944c065f076c4e5d7db907f30d61e03805c50ecbeaec7b2536ef43ab5955"
    sha256 cellar: :any_skip_relocation, sonoma:        "267ab6e5180efd05531a74e1aa6dfd7483041911ff0d3657a0d7b7e2b398446a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0fb15fcd4fee6b11e292ba6abe3bfcef54dedc4b40279147e7744c46c2c88d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cf58182ff75ae2ddb147fb4322be572b0ae701d7b9e443d6b2a705342a9e6c8"
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
