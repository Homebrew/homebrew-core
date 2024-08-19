class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.52.tar.gz"
  sha256 "8970a11b2116cccf74e42d3002dbb599dadbe54cb8af12f9f8d407c894221e24"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47ba0bbf7ba411522f8c21df7dc8db0f7d8890e66403d84d34f5a2b83ed64b7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "404f46dd8bfb2b4ed7bef0ef239dbcca83228921650ba53000f444db96dc33ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da3776c96cb861fb8b2d40df3a907337524d0f3b2e268832ae504849ff6d30ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "a496e68dd77328de82e60a77b242db37b6c119e853f6b00055e988d517c720ef"
    sha256 cellar: :any_skip_relocation, ventura:        "eb0353d11c684f5ff867be390cabec90e404cbb40dea3f801316a676cce781a4"
    sha256 cellar: :any_skip_relocation, monterey:       "fbe015ed6c582359ecfb2a8d547159832c086059c094ad13d3c3c71905f6e7cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "838d6a2fe0ad180562cc20f9b2b9162be9ba5d19ac50a07bc40cbfad6e9b7634"
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
