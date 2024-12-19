class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v17.1.0.tar.gz"
  sha256 "5f44f1058680c86a8c68053d4d5ce40ff003f8732bd54f154a42513a3517f1f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "457a10b1a85bcb681f81c083cac88cd0cba2eb8444a6d08bd8c4d448016d3ced"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "457a10b1a85bcb681f81c083cac88cd0cba2eb8444a6d08bd8c4d448016d3ced"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "457a10b1a85bcb681f81c083cac88cd0cba2eb8444a6d08bd8c4d448016d3ced"
    sha256 cellar: :any_skip_relocation, sonoma:        "54ec035576fa51aed947428840d6e6003645ba4cf8c9494466d56a221674ea58"
    sha256 cellar: :any_skip_relocation, ventura:       "54ec035576fa51aed947428840d6e6003645ba4cf8c9494466d56a221674ea58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "778ba7ceee600c2467e502a7acc414cadef4f1b5d311e2d76293e5cad8c56a8a"
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
