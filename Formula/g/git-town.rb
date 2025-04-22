class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v19.0.0.tar.gz"
  sha256 "45140bc35035e78cc3909761623f81316fd3d802dc27a1f4c3052117a3a1973a"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f1063bd318df648613b9cd7312126bbae5c0b40399dc26819c2c729e1232b97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f1063bd318df648613b9cd7312126bbae5c0b40399dc26819c2c729e1232b97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f1063bd318df648613b9cd7312126bbae5c0b40399dc26819c2c729e1232b97"
    sha256 cellar: :any_skip_relocation, sonoma:        "1187efa3ef6785da1361295e7e660f8be0ffca5f202dd65622e8cdf31faf6039"
    sha256 cellar: :any_skip_relocation, ventura:       "1187efa3ef6785da1361295e7e660f8be0ffca5f202dd65622e8cdf31faf6039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2edaccf2b1945a30fe522d5dc9ee3c9c67d4487100e1a39056874aed32673c00"
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
