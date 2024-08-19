class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v15.1.0.tar.gz"
  sha256 "77d78a8e7c0352fc0993e44df668630ac48a5396fca9e3e1857d8a2381c38017"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fdf6a49be72decc390e36f29b8bfa2d7471a21e14fc56fd69e77918adc0bd35e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2e1fc75ddb4b60ba34577320ed49f8120c9f50a6988f2e843d04a8644198821"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d4c027b3c2c09b254447e75960d7c66e4da255e29c87f230c11bcd876a38b2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a106c7aa60cd39e570092c83dabbb4156aaae867199e04aba869ab9e4f7a980d"
    sha256 cellar: :any_skip_relocation, ventura:        "ea11d5e457be8f4cf13920644769df21de8561f2df4005c8ad8cc4db78c8d549"
    sha256 cellar: :any_skip_relocation, monterey:       "9756fab856a1c55c24b6f68715316d58624092b226a924907e405551d53c687b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ef3b6a46afa3c86c17f1ba17f2ea52b63d26fc37de33dfe7df756fbb56e9a48"
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
