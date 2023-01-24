class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/7.9.0.tar.gz"
  sha256 "9c2308cb78ee04743830fe045edc78d2869d9edc31c7a191eed4f846166284b9"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b343b2c422a5a24dab01898ab26df1e162ec9e64cf44f2eb74d935dc7ab339e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee5cfa9fc2de4d7f94e02db8ec2c6569db3d73acba189cf3110ac98f4fa42216"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7836f809eba851742cc1d32e9e25cce77c6e82a89692042806305804b9e949a0"
    sha256 cellar: :any_skip_relocation, ventura:        "a6f996886438530b1473a43bcf97b2959cf5fba1e02c8a91ca2967b083f1c31b"
    sha256 cellar: :any_skip_relocation, monterey:       "6948614e286564a36b170a25ada1baeaaf135ae5e21f9b82a33a78d03d8a6ba6"
    sha256 cellar: :any_skip_relocation, big_sur:        "82694b019054c8bf26789cea5617cecc19c4877354aa48c062daec3ec369fefc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89e6883eef1bd07368781e0c2cdef3da5a6487ae5aaeb333ee055fe127841858"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v7/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v7/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "install", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town version")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
