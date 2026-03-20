class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v22.6.0.tar.gz"
  sha256 "446927d48ae07a9978a70d5ede49484dda5fe61914e2b7ecfec18e95c739a60d"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcaefed7b506218e1da7dacb00fb5a6ccea0222da8b847ba34d6bf5dc6aea283"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcaefed7b506218e1da7dacb00fb5a6ccea0222da8b847ba34d6bf5dc6aea283"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcaefed7b506218e1da7dacb00fb5a6ccea0222da8b847ba34d6bf5dc6aea283"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3d603f69fbe90d0e4192b956c31db985f3eb700fb2becf55da6cbc1cc03ff22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3b7ea70ca0d5435759263a0635a703e521a4bada86339e00f35a02a33dec5c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66f7e69d6bc608c3f40dd26051d4c807715401b9aa7fd952e15774082e65b5a7"
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
