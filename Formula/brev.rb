class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.73.tar.gz"
  sha256 "902910cb896591108370eadb4b1005e82daea3e2401df88f337292ef2275ee45"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "355c2e288d78c980b4622e57f29c09ca59958c42e1fd6614b80310b6c4b05ffd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c82700c3b48d25ccf86c550f35274d7b7de827449976e20127efa5619c42b4a"
    sha256 cellar: :any_skip_relocation, monterey:       "7b0d2c2db1d9215b05c9750663d4318621a5cbdcd19549ca3f750e321c14231f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bed0bcc92bdcaf5a334fdd1a9f24f3c7acbbee44fca4ce6866916d2d8de69ba"
    sha256 cellar: :any_skip_relocation, catalina:       "7e697334bb2d0826889269265e601c3ea9a115b88f1692373d16ef6b086409f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a1a94a1b95bda75c2af8686c1592766d2aa5274ae1b153a33b7063cee895569"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
