class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.153.tar.gz"
  sha256 "532e4661aca12da56aa4029429027c7dc8fb88e99ba78e4bf6ee74f4c1e0b93e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6763634937ddfd9fd1faf19a9ee23c0ec5a7a7d2ae406206976d280eb485ee7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "795d55171356325ccb57f3ba632b538ec29a1c4197585c1027b1a408e78e5a2a"
    sha256 cellar: :any_skip_relocation, monterey:       "ac731461ad9a40c75dc0130404840e1f4dec858ba81fa241314d20c2562d9b43"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b755828928e13c88abcf5517be9d55e4a4a4789d5f8f91386fb9c42fe32dcb6"
    sha256 cellar: :any_skip_relocation, catalina:       "a9b1c3489d6ed28d4a484b9c2077b0f9f8474aafb6b92dece32fefca7a059a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "085ac188e137b9831a1ca9288af95c577fab485b8cf5ea3e196aaf4f84ba2882"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks instead of inet.af/netstack/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
