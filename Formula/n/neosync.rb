class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.3.59.tar.gz"
  sha256 "991b0becb73736285db34f0bc99531c187522a44a525070edffca92d0d31ac17"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3bae4540043dc5ef731ec102ed8b07ecfff0fb227fe876d01b1f6f27a54a1d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df949ad70e9a0b0367fb07f16f24bafbed2c41c73efdbc2a800745ae644cfe62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1adbb0a1b5ccad35ea28619344c93479e41b98db78b01104bdd987a84a59e382"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a544f13e0c63f393e824e374b863b3933646b684aaf300a687aceec019bf0e1"
    sha256 cellar: :any_skip_relocation, ventura:        "447feae6e657d7244b9e56dfae808cf9bd6ee0f3e9ed856a3995c7e336dc27d5"
    sha256 cellar: :any_skip_relocation, monterey:       "00be4bc0b344c1cf8adf82a90b60c0ff2180fcea7e658c341e4b1a7c364c8cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9650c7b1d831f83cac90f2137df4c95981fd803a1d1b7005f4476088e56c370"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/neosync"
    end

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
