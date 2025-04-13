class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v18.3.2.tar.gz"
  sha256 "ec762f740f100b1d8c0478bc17246bd2df24158763f35e5d0a414f7e90b44aee"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c75edfe9caac5780d40d9917d01f5ea0371277566cedbc187cf05f109819aac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c75edfe9caac5780d40d9917d01f5ea0371277566cedbc187cf05f109819aac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c75edfe9caac5780d40d9917d01f5ea0371277566cedbc187cf05f109819aac"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f3d73f05f8b31b108f30ce40117624b9c9d8906de2809b378b20d81a90933fe"
    sha256 cellar: :any_skip_relocation, ventura:       "8f3d73f05f8b31b108f30ce40117624b9c9d8906de2809b378b20d81a90933fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dfe09b6596445d1dc2a5f32191536f5ac6267682332f1bdca7bddf74415499a"
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
