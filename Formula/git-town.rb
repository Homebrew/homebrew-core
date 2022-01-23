class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/v7.7.0.tar.gz"
  sha256 "edc4f87ef904ac297b9fbb30014e2ab474ee633c1687ed5011b38cd6f8b950e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01ada2ed0fedb174a5be04898f2438ba96c54ed732457830cbaf478457d049fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93ee6a1f35e0653ef2ea849bcac1500bff906b03dc0939b211aa62e621dc0527"
    sha256 cellar: :any_skip_relocation, monterey:       "5dc8a6f7b97171e850ccb9116ee2db746c5385889f80bb442c8ce0e225cfc2b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "85ddb2715a2d478b814dd12430f7aece5c82f39ea56cb05550b7fb5a20173ba3"
    sha256 cellar: :any_skip_relocation, catalina:       "3276dd53179d3d675ef7b3e1dd76ecf51b9fbcae54a3f2ba6473350c2241c078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d04a0eae9958949388a79a22d688fcbd21da070ef9d29c9a9c416d7ef1bd552"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/git-town/git-town/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town version")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system "#{bin}/git-town", "config"
  end
end
