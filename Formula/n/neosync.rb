class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.34.tar.gz"
  sha256 "51e17b3bdb723b50b07ede45b2cdc65dedd7fcaf24e046741a72e0f0f49c8bde"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6f36c8725dcd84b373f796fdf3de6585ef59d51140d9710c27bcc1b6a4646f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "197df4b0a51b6fa6d3c42f14b30999bb38e439b18eb283733473cc1d613bfdd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4a5bf441ad9c8ee233a93891f3e15503ed6bb325d0c7548b8928a5ba08ce086"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b6449e5d5c6f450deeb22b7a25565344404aa12bc55ca0c36d9418b90eec134"
    sha256 cellar: :any_skip_relocation, ventura:        "133ec03dbbdf2f1b3670e35a819e2496f4a6ef0e16ee958f6eb5efcd7d252db6"
    sha256 cellar: :any_skip_relocation, monterey:       "80c6e79cf2d0e639008c089281fc016f20bab8de9f765df27091f6f68f4b3bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e44d601245b479cbc1fbb7e20bf2f8e734328e2b0be67d15c9b1f6865c962cb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
