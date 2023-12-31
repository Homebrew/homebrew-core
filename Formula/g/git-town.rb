class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v11.1.0.tar.gz"
  sha256 "59386dce9d849c68a5363106e5f1200c8a930c998059ecfdc46cd5aa1acff49b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94dd573d9cc47191ea5f69903ea663450bb97df683e84df880115ed8e27a391d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3d14e68fb767bb210f1bb9a54a0f946777702bc28168f5a18c1b95770f07200"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "735c900eb5723cdca4f13e06d92c803e9ba92ae632f589f26a5e5135035c0a2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "26b76952d38f10f5c44260cb7ded0cd0246298f4eca7089d93063178ff0d48e4"
    sha256 cellar: :any_skip_relocation, ventura:        "9aaaf3a7c4d948c93f527635fb7c2578dca3fdd543e7972b2ca3bb10f3839151"
    sha256 cellar: :any_skip_relocation, monterey:       "af14fc93535ac96460ef3c4a8f9db44f2640c5a53d3076d898a5328eab816319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10a933d8120cecab640728c9b630979fd67c61dcfc3dbae3a195e93c02306f46"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v11/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v11/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

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
