class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v23.0.1.tar.gz"
  sha256 "88f4cb8949a04ee0e8f4bc1e207568b0969e7094e62ab1e95c8562e0c7c84408"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0533352a0fb2ea96618accde32f631eb736bd02a3633dfbcf3eddcff46279b67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0533352a0fb2ea96618accde32f631eb736bd02a3633dfbcf3eddcff46279b67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0533352a0fb2ea96618accde32f631eb736bd02a3633dfbcf3eddcff46279b67"
    sha256 cellar: :any_skip_relocation, sonoma:        "160d4c24e238b5574f822cd2fcd7dd837c34b23a9be3de69357ca456f3653033"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c004b49fdde2541b5af9df887a681ffe0aa99c377e60d1d658e3edf02918c1d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6edc671adf6ff013fa821d7380550f1593853d27faa3875d35e3bb1bebed943a"
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
