class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.3.56.tar.gz"
  sha256 "44514f1e689ec7190974cb989a5f91cc5978c9eb37f012bf8b6738d86d201bf4"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94e2dfb4ae2b48374d17220c28f8dbb0fcc2216c5536a69fdebb082c3ed511f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ae096ec917ed05989f4b6f0e71664620aa4eb9b5eb69624f46fef1e34382284"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0521e0b0a6eb54cd17406fd645abf49e6bc7aa7aecc2dab81ac053960d1d9c45"
    sha256 cellar: :any_skip_relocation, sonoma:         "a79ce3c16c4b69c1b5ad7788d9b39d0d87afed75737c7616e6b9fa13617232ca"
    sha256 cellar: :any_skip_relocation, ventura:        "36322f5b87c5922465efa1abed7de041cde06278cfa73e8edc94016c4bcf4e5d"
    sha256 cellar: :any_skip_relocation, monterey:       "2c52323d6df6ee14baa98e09bfda5aec5aa4147b7a13dd4613d0b2f44e3c3684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2459e5ff690b81a24bfc699890c4ba0384cceed93148ae22b6cd4e4e0f4a07a5"
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
