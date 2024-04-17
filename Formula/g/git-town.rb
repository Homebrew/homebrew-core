class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v14.0.0.tar.gz"
  sha256 "2113f0d3ee2fdde965e614bd3841ee085219547adf8f63f017c9b38737484eb7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "079a44555bc23fa6e76b1f70a72afea64fe79442e2c7b46795238d855b62ec52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d593859bad97067bc41bdf43a05d2f58fece6c5059567c200113d2dbf8fccd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62772c4e1780b314e24d3c8b3865680c68db32d3ac0118b402ac7d741a645e56"
    sha256 cellar: :any_skip_relocation, sonoma:         "b48a8b7957934818d04509f9cef90855ef9dd650ca32163f2a48e5a5b44af030"
    sha256 cellar: :any_skip_relocation, ventura:        "718993d682011cd810b3fcc41d01376340152362f660cef43a2cd51c82593f11"
    sha256 cellar: :any_skip_relocation, monterey:       "e52250ccdace4f41adf19bd6e7c46df8f63b97d1bc166e85a065d4a3c926eca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36cc6130afabf9a4686a66e0548c360537e041534a495479e289ece536cfefb0"
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
